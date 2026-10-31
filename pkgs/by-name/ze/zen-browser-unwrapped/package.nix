{
  buildMozillaMach,
  buildNpmPackage,
  fetchFromGitHub,
  fetchNpmDeps,
  writeScriptBin,
  runtimeShell,
  rustPlatform,
  vips,
  lib,
  fetchurl,
  callPackage,
  python3Minimal,
  patch,
  pkg-config,
  nixosTests,
  cargo,
}:

let
  version = "1.23.4b";
  firefoxVersion = "158.0.1";
  surferRev = "b3fc8ab971bd5eb4dc680391c16324b4b80adfa8";
  surferVersion = "1.14.9-unstable-2026-10-20";

  firefoxSrc = fetchurl {
    url = "https://archive.mozilla.org/pub/firefox/releases/${firefoxVersion}/source/firefox-${firefoxVersion}.source.tar.xz";
    hash = "sha256-tb7/VfpzoppnSoZ9pZIvXXaZ9R41Hmu+RAX8xLpVqCQ=";
  };

  desktopSrc = fetchFromGitHub {
    owner = "zen-browser";
    repo = "desktop";
    tag = version;
    hash = "sha256-8hXSzjjCxDO/uLb2DgPYH8bgLXLjuM421FI7CD9fMU4=";
    fetchSubmodules = true;
  };

  surferSrc = fetchFromGitHub {
    owner = "zen-browser";
    repo = "surfer";
    rev = surferRev;
    hash = "sha256-xg4MpAIetcAUOCyYDDMmM+ZD4DYFPLe+08y77G4B8So=";
  };

  patchedSurfer = buildNpmPackage {
    pname = "surfer-patched";
    version = surferVersion;

    src = surferSrc;

    nativeBuildInputs = [ pkg-config ];
    # TODO: this should be in nativeBuildInputs, since sharp is only used during build, but it doesn't seem to be
    # visible in there. why not?
    buildInputs = [ vips ];

    patches = [
      ./patch-surfer-git-usage.patch
    ];

    npmDepsHash = "sha256-z7rqACW/s/hg98Ipa2UL9trsq39zY9KABQBSGjRtF8o=";
    makeCacheWritable = true;
  };

  patchedSrc = buildNpmPackage (finalAttrs: {
    pname = "firefox-zen-browser-src-patched";
    inherit version;
    inherit (patchedSurfer) buildInputs; # Requires surfer deps still because surfer is still in package.json

    src = desktopSrc;

    postUnpack = ''
      tar xf ${firefoxSrc}
      rm -rf source/engine
      mv firefox-${firefoxVersion} source/engine
    '';

    npmDepsHash = "sha256-kBquKwMPQD/h50dFW4eST9shJq+xoOVX3uja2Mk8D5c=";

    # Excluded from the npm dependencies fetcher: the postPatch hook applies the
    # engine patches of the prepared source and requires the source tree of the
    # build itself, which the fetcher does not have.
    npmDeps = fetchNpmDeps {
      inherit (finalAttrs) src;
      hash = finalAttrs.npmDepsHash;
      postPatch = "";
      patches = [ ];
    };

    makeCacheWritable = true;

    postConfigure = ''
      rm -rf node_modules/@zen-browser/surfer
      cp -a ${patchedSurfer}/lib/node_modules/@zen-browser/surfer/. node_modules/@zen-browser/surfer/
      patchShebangs node_modules/@zen-browser/surfer
    '';

    # NOTE: this is used for the ffprefs step.
    cargoDeps = rustPlatform.fetchCargoVendor {
      pname = "zen-browser-ffprefs";
      inherit (finalAttrs) version src cargoRoot;
      hash = "sha256-DZMwxeulQiIiSATU0MoyqiUMA0USZq6umhkr67hZH1Q=";
    };
    cargoRoot = "tools/ffprefs";

    # Exposed so the update script can recalculate the cargo dependency hash.
    passthru = {
      inherit (finalAttrs) cargoDeps;
    };

    postPatch = ''
      patchCount=0

      trackPatch() {
        patch -d "$PWD/engine" -p1 -l -i "$1"
        patchCount=$((patchCount + 1))
      }

      for p in $(find ${patchedSurfer}/lib/node_modules/@zen-browser/surfer/template/patches.optional -name '*.patch' | LC_ALL=C sort); do
        trackPatch "$p"
      done

      find src -type f ! -name '*.patch' ! -path 'src/node_modules/*' | LC_ALL=C sort | while read -r file; do
        rel=''${file#src/}
        target="engine/''${rel}"
        mkdir -p "''${target%/*}"
        cp "$file" "$target"
      done

      for p in $(find src -name '*.patch' | LC_ALL=C sort); do
        trackPatch "$PWD/$p"
      done

      echo "applied $patchCount tracked patches"
    '';

    nativeBuildInputs = patchedSurfer.nativeBuildInputs ++ [
      cargo
      python3Minimal
      patch
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

      ./node_modules/.bin/surfer ci --brand release --display-version ${version}
      SURFER_NO_TRACKED_PATCHES=1 npm run import
      python scripts/update_en_US_packs.py

      SURFER_MOZCONFIG_ONLY=1 ./node_modules/.bin/surfer build --skip-patch-check

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
  binaryName = "zen";
  branding = "browser/branding/release";

  src = patchedSrc;

  extraConfigureFlags = [
    "--with-app-basename=Zen"
  ];

  tests = { inherit (nixosTests) zen-browser; };
  updateScript = callPackage ./update.nix {
    attrPath = "zen-browser-unwrapped";
  };

  # Fetchers and version keys exposed to the update script.
  extraPassthru = {
    inherit
      desktopSrc
      firefoxSrc
      firefoxVersion
      patchedSurfer
      surferSrc
      surferVersion
      ;
  };

  meta = {
    description = "Firefox based browser with a focus on privacy and customization";
    homepage = "https://zen-browser.app ";
    downloadPage = "https://zen-browser.app/download";
    changelog = "https://zen-browser.app/release-notes/#${version}";
    maintainers = with lib.maintainers; [
      matthewpi
      titaniumtown
      eveeifyeve
      _0x4bs3nt
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    # since Firefox 60, build on 32-bit platforms fails with "out of memory".
    # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
    maxSilent = 14400; # 4h, double the default of 7200s (c.f. #129212, #129115)
    license = lib.licenses.mpl20;
    mainProgram = "zen";
  };
}).override
  {
    enableAddonSigning = false;
    enableAddonSideload = true;
    enableCrashReporter = false;
    enableOfficialBranding = true;
  }
