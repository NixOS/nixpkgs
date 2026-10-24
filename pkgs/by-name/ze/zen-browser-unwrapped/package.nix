{
  lib,
  buildMozillaMach,
  buildNpmPackage,
  fetchFromGitHub,
  fetchurl,
  gitMinimal,
  jq,
  nixosTests,
  nodejs_22,
  pkg-config,
  python3,
  rustPlatform,
  vips,
}:

let
  version = "1.23.4b";
  firefoxVersion = "158.0.1";
  firefoxL10nRev = "c44df40e05db615d5ab810f916ecd415714b4a55";
  pgoCorpusRev = "3967678fa8ab98d847ab33cf3728dba726fa854b";

  zenSource = fetchFromGitHub {
    owner = "zen-browser";
    repo = "desktop";
    tag = version;
    hash = "sha256-8hXSzjjCxDO/uLb2DgPYH8bgLXLjuM421FI7CD9fMU4=";
  };

  firefoxSource = fetchurl {
    url = "mirror://mozilla/firefox/releases/${firefoxVersion}/source/firefox-${firefoxVersion}.source.tar.xz";
    hash = "sha256-tb7/VfpzoppnSoZ9pZIvXXaZ9R41Hmu+RAX8xLpVqCQ=";
  };

  firefoxL10n = fetchFromGitHub {
    owner = "mozilla-l10n";
    repo = "firefox-l10n";
    rev = firefoxL10nRev;
    hash = "sha256-QuYvYpx5whD5sSXWUFs30WX96NK3/DYVl/hZwCqA17U=";
  };

  # Matches pgo-extended-corpus in Firefox's taskcluster/kinds/fetch/benchmarks.yml.
  pgoCorpus = fetchurl {
    url = "https://github.com/WebKit/JetStream/archive/${pgoCorpusRev}.tar.gz";
    hash = "sha256-1i6dwirmtSs9Rnp/vUVon7t33dV6T9VkIsD/sCLU+e4=";
  };

  ffprefs = rustPlatform.buildRustPackage {
    pname = "zen-browser-ffprefs";
    inherit version;
    src = zenSource;
    sourceRoot = "source/tools/ffprefs";
    cargoHash = "sha256-DZMwxeulQiIiSATU0MoyqiUMA0USZq6umhkr67hZH1Q=";
  };

  preparedSource = buildNpmPackage {
    pname = "zen-browser-source";
    inherit version;
    src = zenSource;
    nodejs = nodejs_22; # Matches upstream's .nvmrc.
    npmDepsHash = "sha256-kBquKwMPQD/h50dFW4eST9shJq+xoOVX3uja2Mk8D5c=";
    makeCacheWritable = true;

    nativeBuildInputs = [
      ffprefs
      gitMinimal
      jq
      pkg-config
      python3
    ];
    buildInputs = [ vips ];

    postConfigure = ''
      # The pinned Firefox source is supplied by Nix; builds cannot check the network.
      substituteInPlace node_modules/@zen-browser/surfer/dist/index.js \
        --replace-fail 'await (0, update_check_1.updateCheck)();' ""
    '';

    buildPhase = ''
      runHook preBuild

      jq -e \
        '.version.version == "${firefoxVersion}" and .brands.release.release.displayVersion == "${version}"' \
        surfer.json
      test "$(cat build/firefox-cache/l10n-last-commit-hash)" = "${firefoxL10nRev}"

      mkdir engine
      tar -xf ${firefoxSource} -C engine --strip-components=1
      npm exec -- surfer ci --brand release --display-version ${version}
      ffprefs .
      python scripts/update_service_dumps.py
      npm exec -- surfer import
      python scripts/update_en_US_packs.py

      # Match upstream's language preparation using the pinned Mozilla translations.
      python - <<'PY'
      import shutil
      import sys
      from pathlib import Path

      sys.path.insert(0, "scripts")
      from copy_language_pack import copy_browser_locales, get_language_code

      locales = []
      for language in Path("locales/supported-languages").read_text().split():
          locale = get_language_code(language)
          shutil.copytree(
              Path("${firefoxL10n}") / locale,
              Path("locales") / language,
              dirs_exist_ok=True,
          )
          copy_browser_locales(language)
          locales.append(locale)
      Path("engine/browser/locales/zen-locales").write_text(" ".join(locales) + "\n")
      PY

      # Surfer normally writes these during compilation, which buildMozillaMach handles.
      for file in version.txt version_display.txt; do
        echo ${version} > engine/browser/config/$file
      done

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      # Surfer links source files into the engine tree; make the result self-contained.
      cp -rL engine "$out"

      runHook postInstall
    '';

    dontFixup = true;
  };
in
(
  (buildMozillaMach {
    pname = "zen-browser";
    version = firefoxVersion;
    packageVersion = version;
    applicationName = "Zen";
    binaryName = "zen";
    branding = "browser/branding/release";
    src = preparedSource;

    extraConfigureFlags = [
      "--with-app-basename=Zen"
      "--enable-update-channel=release"
    ];

    extraPreConfigure = ''
      # Match upstream's compile-time telemetry setting as well as its preferences.
      export MOZ_TELEMETRY_REPORTING=

      # Zen uses the underlying Firefox version for extension compatibility and blocklists.
      export ZEN_FIREFOX_VERSION=${firefoxVersion}

      configureFlagsArray+=("--with-l10n-base=$PWD/browser/locales")
    '';

    tests = { inherit (nixosTests) zen-browser; };
    updateScript = ./update.sh;

    extraPassthru = {
      inherit
        ffprefs
        firefoxL10n
        firefoxL10nRev
        firefoxSource
        firefoxVersion
        pgoCorpus
        pgoCorpusRev
        zenSource
        ;
    };

    meta = {
      description = "Firefox-based browser with vertical tabs and workspaces";
      homepage = "https://zen-browser.app/";
      changelog = "https://github.com/zen-browser/desktop/releases/tag/${version}";
      license = lib.licenses.mpl20;
      maintainers = [ lib.maintainers._0x4bs3nt ];
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      mainProgram = "zen";
    };
  }).override
    {
      enableAddonSigning = false;
      enableAddonSideload = true;
      enableCrashReporter = false;
      enableDataReporting = false;
    }
).overrideAttrs
  (old: {
    profilingPhase = lib.optionalString (old.profilingPhase != "") (
      assert lib.hasInfix "./mach python ./build/pgo/profileserver.py" old.profilingPhase;
      ''
        # Use the same extended training corpus as upstream's Linux release build.
        ./mach python - <<'PY'
        import base64
        import yaml

        with open("taskcluster/kinds/fetch/benchmarks.yml") as manifest:
            corpus = yaml.safe_load(manifest)["pgo-extended-corpus"]["fetch"]
        assert corpus["url"] == "${pgoCorpus.url}"
        assert "sha256-" + base64.b64encode(bytes.fromhex(corpus["sha256"])).decode() == "${pgoCorpus.outputHash}"
        PY

        mkdir -p "$TMPDIR/pgo-extended-corpus/JetStream"
        tar -xf ${pgoCorpus} -C "$TMPDIR/pgo-extended-corpus/JetStream" --strip-components=1
      ''
      +
        lib.replaceStrings
          [ "./mach python ./build/pgo/profileserver.py" ]
          [ "./mach python ./build/pgo/profileserver.py --extended-corpus \"$TMPDIR/pgo-extended-corpus\"" ]
          old.profilingPhase
    );

    preInstall = ''
      # Preserve the locale list when the shared builder's install target repackages.
      export MOZ_CHROME_MULTILOCALE="$(cat browser/locales/zen-locales)"
      MOZ_AUTOMATION=1 ./mach package-multi-locale --locales $MOZ_CHROME_MULTILOCALE
    ''
    + old.preInstall;

    installCheckPhase = old.installCheckPhase + ''
      PYTHONPATH=python/mozbuild python - "$out/lib/zen" <<'PY'
      import sys
      from pathlib import Path
      from mozpack.mozjar import JarReader

      expected = set(Path("browser/locales/zen-locales").read_text().split()) | {"en-US"}
      for archive in ("omni.ja", "browser/omni.ja"):
          jar = JarReader(str(Path(sys.argv[1]) / archive))
          actual = {
              entry.filename.split("/")[1]
              for entry in jar
              if entry.filename.startswith("localization/")
          }
          assert actual == expected, (archive, expected - actual, actual - expected)
      print(f"Verified all {len(expected)} locales in both installed resource archives")
      PY
    '';
  })
