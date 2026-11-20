{
  buildNpmPackage,
  cacert,
  # Keep the major version in sync with "electron" in package.json
  electron_43,
  fetchFromGitHub,
  fetchurl,
  lib,
  makeWrapper,
  nodejs,
  npmHooks,
  stdenv,
  stdenvNoCC,
  unzip,
}:
buildNpmPackage (finalAttrs: {
  pname = "turbowarp-desktop";
  version = "1.17.1";
  src = fetchFromGitHub {
    owner = "TurboWarp";
    repo = "desktop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GlskCKs3ywxYaajdYKUrTUHAG4yUJrj5/5Rvz+cEJSQ=";
  };
  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-tAjI/z20HpBEyKmTpeXa2M/TZ3riMzbNpP1APB3n8Qg=";
  forceGitDeps = true;

  __structuredAttrs = true;

  nativeBuildInputs = [
    unzip
    makeWrapper
  ];

  # Upstream downloads these during `npm run fetch` and the scratch-gui
  # prepublish script, which cannot run in the sandbox. Each one is fetched
  # separately with a fixed hash and put in place in buildPhase.
  # To update a fixed-output hash, set it to lib.fakeHash and copy the real
  # value from the build error.
  passthru = {
    # Keep in sync with node_modules/scratch-gui/scripts/prepublish.mjs
    microbitHexZip = fetchurl {
      url = "https://packagerdata.turbowarp.org/scratch-microbit-1.2.0.hex.zip";
      hash = "sha256-39V0twkwf+dsRNu2sKyJQueQj01cGDWfriX72jyfQ5k=";
    };

    # Output of scripts/download-library-files.mjs
    libraryFiles = stdenvNoCC.mkDerivation {
      pname = "turbowarp-desktop-library-files";
      inherit (finalAttrs) version src;

      nativeBuildInputs = [
        nodejs
        cacert
      ];

      buildPhase = ''
        runHook preBuild
        node scripts/download-library-files.mjs
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        cp -r dist-library-files $out
        runHook postInstall
      '';

      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
      outputHash = "sha256-5jkJf+Jm69B/vlzAicQmgQiqqFbip3z2pphAejc6n8M=";
    };

    # Replaces the cached-extension-dependencies directory that
    # @turbowarp/extensions creates with fetchAllDependencies(). The extensions
    # version comes from package-lock.json, so only the hash needs updating.
    extensionDependencies = stdenvNoCC.mkDerivation {
      pname = "turbowarp-extensions-cached-dependencies";
      inherit (finalAttrs)
        version
        src
        npmDeps
        forceGitDeps
        ;

      nativeBuildInputs = [
        nodejs
        npmHooks.npmConfigHook
        cacert
      ];

      buildPhase = ''
        runHook preBuild
        node --input-type=module -e "
          import { fetchAllDependencies } from './node_modules/@turbowarp/extensions/development/dependency-management.js';
          await fetchAllDependencies();
        "
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        cp -r node_modules/@turbowarp/extensions/cached-extension-dependencies $out
        runHook postInstall
      '';

      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
      outputHash = "sha256-NLBopgg7bh/hgDbe0oZ0LiVU6+8ybQwb/B6UUMAfxl0=";
    };

    # Built from source instead of downloading the release asset that
    # scripts/download-packager.mjs fetches.
    packagerStandalone = buildNpmPackage (packagerFinalAttrs: {
      pname = "turbowarp-packager-standalone";
      # Keep in sync with scripts/packager.json
      version = "3.14.0";

      src = fetchFromGitHub {
        owner = "TurboWarp";
        repo = "packager";
        tag = "v${packagerFinalAttrs.version}";
        hash = "sha256-Hde1SkRarFFl/a9Wgpod6dDQefoJ7V2Z1vCs3ddMe8E=";
      };
      npmDepsFetcherVersion = 2;
      npmDepsHash = "sha256-8SsNUGksaeJpgzXxOp6ZtKi7kJ0b8nWP9sY9B47+PZQ=";
      forceGitDeps = true;
      npmBuildScript = "build-standalone-prod";
      installPhase = ''
        runHook preInstall
        install -Dm644 dist/standalone.html -t $out/share/turbowarp-packager
        runHook postInstall
      '';
    });
  };

  # FIXME: remove once https://github.com/NixOS/nixpkgs/pull/547948 is merged
  # The patched npm used by buildNpmPackage reads these from the environment
  # when building git dependencies, but __structuredAttrs does not export them.
  prePatch = ''
    export stdenv
    export forceGitDeps=1
  '';

  buildPhase = ''
    runHook preBuild

    # Replacement for scratch-gui/scripts/prepublish.mjs
    pushd node_modules/scratch-gui
    mkdir -p static/microbit src/generated
    unzip -j ${finalAttrs.passthru.microbitHexZip} '*.hex' -x '__MACOSX/*' -d static/microbit
    hex=$(basename static/microbit/*.hex)
    echo "module.exports=require('../../static/microbit/$hex');" > src/generated/microbit-hex-url.cjs
    popd

    # Replacement for `npm run fetch`; keep in sync with that script
    cp -r ${finalAttrs.passthru.libraryFiles} dist-library-files
    cp ${finalAttrs.passthru.packagerStandalone}/share/turbowarp-packager/standalone.html src-renderer/packager/standalone.html
    cp -r ${finalAttrs.passthru.extensionDependencies} node_modules/@turbowarp/extensions/cached-extension-dependencies
    node scripts/prepare-extensions.mjs

    npm run webpack:prod

    cp -r ${electron_43.dist} electron-dist
    chmod -R u+w electron-dist

    # tw_update is deliberately not set, so the in-app update checker stays
    # disabled for a Nix-managed package.
    npm exec electron-builder -- \
      --dir \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron_43.version} \
      -c.extraMetadata.tw_dist=nixpkgs \
      -c.mac.identity=null

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    cp -r dist/mac*/TurboWarp.app $out/Applications
    makeWrapper $out/Applications/TurboWarp.app/Contents/MacOS/TurboWarp $out/bin/turbowarp-desktop
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 dist/*-unpacked/resources/app.asar -t $out/share/turbowarp-desktop/resources
    install -Dm644 dist/*-unpacked/linux-files/org.turbowarp.TurboWarp.desktop -t $out/share/applications
    install -Dm644 dist/*-unpacked/linux-files/org.turbowarp.TurboWarp.metainfo.xml -t $out/share/metainfo
    install -Dm644 dist/*-unpacked/linux-files/org.turbowarp.TurboWarp.mime.xml -t $out/share/mime/packages
    install -Dm644 dist/*-unpacked/resources/icon.svg $out/share/icons/hicolor/scalable/apps/org.turbowarp.TurboWarp.svg
    install -Dm644 dist/*-unpacked/resources/icon.png $out/share/icons/hicolor/512x512/apps/org.turbowarp.TurboWarp.png

    substituteInPlace $out/share/applications/org.turbowarp.TurboWarp.desktop \
      --replace "/opt/TurboWarp/turbowarp-desktop" "turbowarp-desktop"

    makeWrapper ${lib.getExe electron_43} $out/bin/turbowarp-desktop \
      --add-flags $out/share/turbowarp-desktop/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --inherit-argv0
  ''
  + ''
    runHook postInstall
  '';

  meta = {
    description = "Scratch mod with a compiler to run projects faster";
    homepage = "https://desktop.turbowarp.org/";
    license = lib.licenses.gpl3Only;
    changelog = "https://github.com/TurboWarp/desktop/blob/v${finalAttrs.version}/changelog.md";
    mainProgram = "turbowarp-desktop";
    maintainers = with lib.maintainers; [ Yukkku ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
