{
  buildMozillaMach,
  buildNpmPackage,
  fetchFromGitHub,
  writeScriptBin,
  runtimeShell,
  rustPlatform,
  vips,
  lib,
  fetchurl,
  callPackage,
  gitMinimal,
  python3Minimal,
  pkg-config,
  nixosTests,
  cargo,
}:

let
  version = "1.19.1b";
  firefoxVersion = "148.0";

  firefoxSrc = fetchurl {
    url = "https://archive.mozilla.org/pub/firefox/releases/${firefoxVersion}/source/firefox-${firefoxVersion}.source.tar.xz";
    hash = "sha256-7JPlBAojt9vp7HfrSnzNqYIIVteFG/L2F/NnO2NUy28";
  };

  patchedSurfer = buildNpmPackage {
    pname = "surfer-patched";
    version = "0-unstable-2026-01-25";

    src = fetchFromGitHub {
      owner = "zen-browser";
      repo = "surfer";
      rev = "6bc7a032ac2b93a4c41763376fa4ddf009bc0cd0";
      hash = "sha256-rX94Y9BgtFoCWN70iHJx1EWLGNBzQrCy2H0at/OiweM=";
    };

    nativeBuildInputs = [ pkg-config ];
    # TODO: this should be in nativeBuildInputs, since sharp is only used during build, but it doesn't seem to be
    # visible in there. why not?
    buildInputs = [ vips ];

    patches = [
      ./patch-surfer-git-usage.patch
    ];

    npmDepsHash = "sha256-+R7RZHwcgm4IdwJuVtwjJvTwRnajSRDF98YbtvajDj4=";
    makeCacheWritable = true;
  };

  patchedSrc = buildNpmPackage (finalAttrs: {
    pname = "firefox-zen-browser-src-patched";
    inherit version;
    inherit (patchedSurfer) buildInputs; # Requires surfer deps still because surfer is still in package.json

    src = fetchFromGitHub {
      owner = "zen-browser";
      repo = "desktop";
      tag = version;
      hash = "sha256-a0Uxwjd8//IKZQhIxnF/pYBtq/FX9CBs5wU4k9tAS2g=";
      fetchSubmodules = true;
    };

    postUnpack = ''
      mkdir source/engine
      tar --extract --file=${firefoxSrc} --directory=source/engine --strip-components=1
    '';

    npmDepsHash = "sha256-OXaKdgH5VV4YrsiaR3MmT7EyZhfKMeK3MyQ/Ha3V6lg=";

    makeCacheWritable = true;

    # NOTE: this is used for the ffprefs step.
    cargoDeps = rustPlatform.fetchCargoVendor {
      pname = "zen-browser-ffprefs";
      inherit (finalAttrs) version src cargoRoot;
      hash = "sha256-DZMwxeulQiIiSATU0MoyqiUMA0USZq6umhkr67hZH1Q";
    };
    cargoRoot = "tools/ffprefs";

    # Requires surfer deps still because surfer is still in package.json
    nativeBuildInputs = patchedSurfer.nativeBuildInputs ++ [
      cargo
      gitMinimal
      python3Minimal
      rustPlatform.cargoCheckHook
      rustPlatform.cargoSetupHook
      (writeScriptBin "iconutil" ''
        #!${runtimeShell}
        echo >&2 "$@"
      '')
      (writeScriptBin "sips" ''
        #!${runtimeShell}
        echo >&2 "$@"
      '')
    ];

    buildPhase = ''
      runHook preBuild

      npm run surfer ci --brand release --display-version ${version}
      npm run import
      python scripts/update_en_US_packs.py

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      cp -r engine $out

      cd $out
      for i in $(find . -type l); do
        realpath=$(readlink $i)
        rm $i
        cp $realpath $i
      done

      runHook postInstall
    '';

    dontFixup = true;
  });
in
(buildMozillaMach {
  pname = "zen-browser";
  packageVersion = version;
  version = firefoxVersion;
  applicationName = "zen";
  branding = "browser/branding/release";
  requireSigning = false;
  allowAddonSideload = true;

  src = patchedSrc;

  extraConfigureFlags = [
    "--with-app-basename=Zen"
  ];

  tests = { inherit (nixosTests) zen-browser; };
  updateScript = callPackage ./update.nix { };

  meta = {
    description = "Firefox based browser with a focus on privacy and customization";
    homepage = "https://zen-browser.app";
    downloadPage = "https://zen-browser.app/download";
    changelog = "https://zen-browser.app/release-notes/#${version}";
    maintainers = with lib.maintainers; [
      matthewpi
      titaniumtown
      eveeifyeve
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    broken = true; # Broken for now because it doesn't build.
    # since Firefox 60, build on 32-bit platforms fails with "out of memory".
    # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
    maxSilent = 14400; # 4h, double the default of 7200s (c.f. #129212, #129115)
    updateScript = callPackage ./update.nix {
      attrPath = "zen-browser-unwrapped";
    };
    license = lib.licenses.mpl20;
  };

}).override
  {
    crashreporterSupport = false;
    enableOfficialBranding = false;
  }
