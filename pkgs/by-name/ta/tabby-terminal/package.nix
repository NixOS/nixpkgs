{
  lib,
  stdenv,

  fetchFromGitHub,
  fetchYarnDeps,
  fetchpatch2,

  copyDesktopItems,
  fixup-yarn-lock,
  makeBinaryWrapper,
  makeDesktopItem,
  replaceVars,
  writableTmpDirAsHomeHook,

  fontconfig,
  libsecret,
  pkg-config,

  electron,
  http-server,
  jq,
  moreutils,
  nodejs,
  patch-package,
  python3,
  yarn,
}:

stdenv.mkDerivation (
  finalAttrs:
  let
    electron41Patch = fetchpatch2 {
      url = "https://github.com/eugeny/tabby/commit/00890fe67969021ca10037ec5b85ec7f9f7edc63.patch";
      hash = "sha256-uGqsnOWWQts10WaPmWvxHNk5jcohhAAUk+3iFs5CK5Y=";
    };

    packages = lib.attrNames finalAttrs.passthru.pkgHashes;
    builtinPlugins = lib.filter (lib.hasPrefix "tabby-") packages;
  in
  {
    pname = "tabby-terminal";
    version = "1.0.230";

    __structuredAttrs = true;
    strictDeps = true;

    src = fetchFromGitHub {
      owner = "Eugeny";
      repo = "tabby";
      tag = "v${finalAttrs.version}";
      hash = "sha256-b9FehwLl5h5HB+Id5cSW9FGp7bDpwUwxfSxB912PkFU=";
      # apply this patch in `src.postCheckout` because it would break the yarn
      # caches + update script when applied through `patches`.
      #
      # bumps node-abi and electron so it can build against a modern version of
      # electron
      postCheckout = "git -C $out apply ${electron41Patch}";
    };

    patches = [
      ./splice-argv.patch
      (replaceVars ./use-nix-version.patch { inherit (finalAttrs) version; })
    ];

    postPatch = ''
      jq '.version = "${finalAttrs.version}"' app/package.json | sponge app/package.json
      substituteInPlace tabby-core/src/configDefaults.yaml \
        --replace-warn 'enableAutomaticUpdates: true' 'enableAutomaticUpdates: false'
    '';

    buildInputs = [
      fontconfig
      libsecret
    ];

    nativeBuildInputs = [
      copyDesktopItems
      makeBinaryWrapper
      writableTmpDirAsHomeHook

      electron
      fixup-yarn-lock
      http-server
      jq
      moreutils
      nodejs
      patch-package
      pkg-config
      (python3.withPackages (
        p: with p; [
          distutils
          gyp
        ]
      ))
      yarn
    ];

    configurePhase = ''
      runHook preConfigure

    ''
    # Loop through all the yarn caches and install the deps for the respective package
    + lib.concatMapStringsSep "\n" (cache: ''
      pushd ${cache.name}
        fixup-yarn-lock yarn.lock
        yarn config --offline set yarn-offline-mirror ${cache.value}
        yarn install \
          --offline \
          --prefer-offline \
          --frozen-lockfile \
          --ignore-scripts \
          --no-progress \
          --non-interactive
        patch-package
        patchShebangs node_modules
      popd
    '') (lib.attrsToList finalAttrs.passthru.yarnCaches)
    + ''
      pushd node_modules
    ''
    # Loop through the "built in" plugins and link them to the node_modules
    + lib.concatMapStringsSep "\n" (plugin: ''
      ln -fs ../${plugin} ${plugin}
    '') builtinPlugins
    + ''
      popd

      # missing type declaration for some reason
      sed -i -e '9a \type VideoFrame = any;' node_modules/electron/electron.d.ts

      runHook postConfigure
    '';

    buildPhase =
      # Start a fake (and completely unnecessary) http-server to let electron-rebuild "download" the headers and hashes
      ''
        runHook preBuild

        mkdir -p http-cache/v${electron.version}
        pushd http-cache/v${electron.version}
          tar \
            --transform 's|^\./|node_headers/|' \
            -czvf node-v${electron.version}-headers.tar.gz \
            -C ${electron.headers} .
          sha256sum node-v${electron.version}-headers.tar.gz > SHASUMS256.txt
        popd
        http-server http-cache &
      ''
      # Rebuild all the needed packages using electron-rebuild
      + lib.concatMapStringsSep "\n" (pkg: ''
        yarn --offline electron-rebuild -v ${electron.version} -m ${pkg} -f -d "http://localhost:8080"
      '') finalAttrs.passthru.rebuildPkgs
      + ''
        kill $!

        yarn build

        runHook postBuild
      '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/tabby
      cp -r . $out/share/tabby

      # Tabby needs TABBY_DEV to run manually with electron
      makeWrapper "${lib.getExe electron}" $out/bin/tabby \
        --add-flags $out/share/tabby/app \
        --set TABBY_DEV 1

      for iconsize in 16 32 64 128
      do
        size="$iconsize"x"$iconsize"
        mkdir -p $out/share/icons/hicolor/$size/apps
        ln -s $out/share/tabby/build/icons/"$size".png $out/share/icons/hicolor/$size/apps/tabby.png
      done

      runHook postInstall
    '';

    desktopItems = lib.singleton (makeDesktopItem {
      name = "tabby";
      desktopName = "Tabby";
      exec = "tabby %u";
      comment = "A terminal for a more modern age";
      icon = "tabby";
      categories = [
        "Utility"
        "TerminalEmulator"
        "System"
      ];
    });

    passthru = {
      pkgHashes = lib.importJSON ./pkg-hashes.json;

      yarnCaches = lib.mapAttrs (
        cacheName: hash:
        fetchYarnDeps {
          name = "offline-${cacheName}";
          src = lib.removeSuffix "/." (finalAttrs.src + "/" + cacheName);
          inherit hash;
        }
      ) finalAttrs.passthru.pkgHashes;

      rebuildPkgs = [
        "app"
        "tabby-core"
        "tabby-local"
        "tabby-ssh"
        "tabby-terminal"
      ];

      updateScript = ./update.sh;
    };

    meta = {
      description = "Terminal for a more modern age";
      homepage = "https://tabby.sh";
      license = lib.licenses.mit;
      mainProgram = "tabby";
      maintainers = with lib.maintainers; [
        dtomvan
        geodic
      ];
      platforms = lib.platforms.linux;
    };
  }
)
