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

      mkdir engine
      tar -xf ${firefoxSource} -C engine --strip-components=1
      npm exec -- surfer ci --brand release --display-version ${version}
      ffprefs .
      python scripts/update_service_dumps.py
      npm exec -- surfer import
      python scripts/update_en_US_packs.py

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
  '';

  tests = { inherit (nixosTests) zen-browser; };
  updateScript = ./update.sh;

  extraPassthru = {
    inherit
      ffprefs
      firefoxSource
      firefoxVersion
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
