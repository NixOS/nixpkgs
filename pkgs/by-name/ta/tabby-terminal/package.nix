{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  fetchYarnDeps,
  nodejs,
  yarn,
  git,
  patch-package,
  electron_32,
  prefetch-yarn-deps,
  fixup-yarn-lock,
  python3,
  makeWrapper,
  http-server,
  fontconfig,
  pkg-config,
  libsecret,
  makeDesktopItem,
  copyDesktopItems,
  jq,
  moreutils,
  applyPatches,
}:

let
  tabby = rec {
    pname = "tabby-terminal";
    version = "1.0.223";

    src = fetchFromGitHub {
      owner = "Eugeny";
      repo = "tabby";
      rev = "v${version}";
      hash = "sha256-YWqbVrxG3/tOw1ERkoEosVlz6k2eTkcsQnHAtdKpkpE=";
      leaveDotGit = true;
    };

    patches = [ ./splice-argv.patch ];

    meta = {
      description = "A terminal for a more modern age";
      homepage = "https://tabby.sh";
      license = lib.licenses.mit;
      mainProgram = "tabby";
      maintainers = with lib.maintainers; [ geodic ];
      platforms = lib.platforms.linux;
    };

    __darwinAllowLocalNetworking = true;

    desktopItems = [
      (makeDesktopItem {
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
      })
    ];

    electronPackage = electron_32;

    electronHeaders = fetchurl {
      url = "https://www.electronjs.org/headers/v${electronPackage.version}/node-v${electronPackage.version}-headers.tar.gz";
      hash = "sha256-D9j1wSDzartWUfDm2UrZDrgum2X+vV+DpDlKPFCtBbA=";
    };

    electronHeadersSHA = fetchurl {
      url = "https://www.electronjs.org/headers/v${electronPackage.version}/SHASUMS256.txt";
      hash = "sha256-ZnWVCzTwwog4kgeFAZGsM2F2mmebrpXMVMxn/K+LWlU=";
    };

    buildInputs = [
      nodejs
      python3
      fontconfig
      electronPackage
    ];

    nativeBuildInputs = [
      git
      yarn
      patch-package
      prefetch-yarn-deps
      fixup-yarn-lock
      (python3.withPackages (python-pkgs: [
        python-pkgs.distutils
        python-pkgs.gyp
      ]))
      makeWrapper
      http-server
      pkg-config
      libsecret
      copyDesktopItems
      jq
      moreutils
    ];

    patchPhase = ''
      runHook prePatch

      jq '.version = "${version}"' app/package.json | sponge app/package.json

      runHook postPatch
    '';

    configurePhase =
      ''
        runHook preConfigure

        export buildDir=$PWD

        git tag ${version}
      ''
      # Loop through all the yarn caches and install the deps for the respective package
      + lib.concatMapStringsSep "\n" (cache: ''
        cd ${cache.pkg}
        export HOME=$PWD/yarn_home
        fixup-yarn-lock yarn.lock
        yarn config --offline set yarn-offline-mirror ${cache.cache}
        echo "Installing deps for ${cache.pkg}"
        yarn install --offline --prefer-offline --frozen-lockfile --ignore-scripts --no-progress --non-interactive
        patch-package
        patchShebangs node_modules
        echo "Done!"
        cd $buildDir
      '') yarnCaches

      + ''
        cd $buildDir/node_modules
      ''
      # Loop thought the "built in" plugins and link them to the node_modules
      + lib.concatMapStringsSep "\n" (plugin: ''
        ln -fs ../${plugin} ${plugin}
      '') builtinPlugins

      + ''
        cd $buildDir

        runHook postConfigure
      '';

    buildPhase =
      # Start a fake (and completely unnecessary) http-server to let electron-rebuild "download" the headers and hashes
      ''
        runHook preBuild

        mkdir -p http-cache/v${electronPackage.version}
        cp $electronHeaders http-cache/v${electronPackage.version}/node-v${electronPackage.version}-headers.tar.gz
        cp $electronHeadersSHA http-cache/v${electronPackage.version}/SHASUMS256.txt
        http-server http-cache &
      ''
      # Rebuild all the needed packages using electron-rebuild
      + lib.concatMapStringsSep "\n" (pkg: ''
        yarn --offline electron-rebuild -v ${electronPackage.version} -m ${pkg} -f -d "http://localhost:8080"
      '') rebuildPkgs
      + ''
        kill $!
        yarn build

        runHook postBuild
      '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/tabby
      mkdir -p $out/bin
      cp -r . $out/share/tabby

      # Tabby needs TABBY_DEV to run manually with electron
      makeWrapper "${electronPackage}/bin/electron" "$out/bin/tabby" --add-flags "$out/share/tabby/app" --set TABBY_DEV 1

      for iconsize in 16 32 64 128
      do
        size=$iconsize"x"$iconsize
        mkdir -p $out/share/icons/hicolor/$size/apps
        ln -s $out/share/tabby/build/icons/"$size".png $out/share/icons/hicolor/$size/apps/tabby.png
      done

      runHook postInstall
    '';
  };

  builtinPlugins = [
    "tabby-core"
    "tabby-settings"
    "tabby-terminal"
    "tabby-web"
    "tabby-community-color-schemes"
    "tabby-ssh"
    "tabby-serial"
    "tabby-telnet"
    "tabby-local"
    "tabby-electron"
    "tabby-plugin-manager"
    "tabby-linkifier"
  ];

  packages = builtinPlugins ++ [
    "."
    "app"
    "web"
    "tabby-web-demo"
  ];

  pkgHashes = lib.importJSON ./pkg-hashes.json;

  # Loop through all the packages and create a yarn cache for them
  yarnCaches = map (pkg: {
    inherit pkg;
    cache = fetchYarnDeps {
      src = lib.removeSuffix "/." (tabby.src + "/" + pkg);
      hash = pkgHashes.${pkg};
    };
  }) packages;

  rebuildPkgs = [
    "app"
    "tabby-core"
    "tabby-local"
    "tabby-ssh"
    "tabby-terminal"
  ];

in
stdenv.mkDerivation tabby
