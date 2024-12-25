{ 
  lib, 
  stdenv, 
  fetchgit, 
  fetchurl, 
  fetchYarnDeps, 
  nodejs, 
  yarn, 
  git, 
  patch-package, 
  electron_29, 
  prefetch-yarn-deps, 
  fixup-yarn-lock, 
  python3, 
  makeWrapper, 
  http-server, 
  fontconfig, 
  pkg-config, 
  libsecret, 
  desktop-file-utils
 }:

let
  tabby = rec {
    pname = "tabby-terminal";
    version = "1.0.215";

    src = fetchgit {
      url = "https://github.com/Eugeny/tabby";
      rev = "refs/tags/v${version}";
      hash = "sha256-euxkvZDIEIMJ8xZKS74easWj0GJOduPClOCiXZfWXPU=";
      leaveDotGit = true;
      deepClone = true;
    };

    meta = with lib; {
      description = "A terminal for a more modern age";
      homepage = "https://tabby.sh";
      license = licenses.mit;
      mainProgram = "tabby";
      maintainers = with maintainers; [ geodic ];
      platforms = [ "x86_64-linux" ];
    };

    # We need to fix the argv logic as tabby only handles it for the node executable, but we are running it with electron
    patches = [./fix-argv-prefix-splice.patch];

    electronVersion = "29.4.6";

    electronHeaders = fetchurl {
      url = "https://www.electronjs.org/headers/v${electronVersion}/node-v${electronVersion}-headers.tar.gz";
      hash = "sha256-e0qiEGI/1rWK72oLXfKtbbc8KmOGMhMx4IbT6MGAjms=";
    };

    electronHeadersSHA = fetchurl {
      url = "https://www.electronjs.org/headers/v${electronVersion}/SHASUMS256.txt";
      hash = "sha256-0mCnKIR3GS1TL+g0h+y2cAlqbBogf88WxN8xJvmFl4g=";
    };

    buildInputs = [
      nodejs
   	  python3
   	  fontconfig
  	  electron_29
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
      desktop-file-utils
    ];

    configurePhase =
      ''
      export buildDir=$PWD
      ''
      # Loop through all the yarn caches and install the deps for the respective package
      + builtins.concatStringsSep "\n" (map (cache:
        ''
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
        ''
      ) yarnCaches)
      + ''
      cd $buildDir/node_modules
      ''
      # Loop thought the "built in" plugins and link them to the node_modules
      + builtins.concatStringsSep "\n" (map (plugin:
        ''
        ln -fs ../${plugin} ${plugin}
        ''
      ) builtinPlugins)
      + ''
      cd $buildDir
      '';

    buildPhase =
      # Start a fake (and completely unnecessary) http-server to let electron-rebuild "download" the headers and hashes
      ''
      mkdir -p http-cache/v${electronVersion}
      cp $electronHeaders http-cache/v${electronVersion}/node-v${electronVersion}-headers.tar.gz
      cp $electronHeadersSHA http-cache/v${electronVersion}/SHASUMS256.txt
      http-server http-cache &
      ''
      # Rebuild all the needed packages using electron-rebuild
      + builtins.concatStringsSep "\n" (map (pkg:
        ''
        yarn --offline electron-rebuild -v ${electronVersion} -m ${pkg} -f -d "http://localhost:8080"
        ''
      ) rebuildPkgs)
      + ''
      kill $!
      yarn build
      
      mkdir -p $out/share/tabby
      mkdir -p $out/bin      
      cp -r . $out/share/tabby
      makeWrapper "${electron_29}/bin/electron" "$out/bin/tabby" --add-flags "$out/share/tabby/app" --set TABBY_DEV 1

      mkdir -p $out/share/icons/hicolor/128x128/apps
      cp ./build/icons/128x128.png $out/share/icons/hicolor/128x128/apps/tabby.png

	  mkdir -p $out/share/applications
	  echo "[Desktop Entry]" > tabby.desktop
      desktop-file-install --dir $out/share/applications \
        --set-key Type --set-value Application \
        --set-key Exec --set-value tabby \
        --set-key Name --set-value Tabby \
        --set-key Comment --set-value "A terminal for a more modern age." \
        --set-key Categories --set-value "Utility;TerminalEmulator;System" \
        --set-key Icon --set-value $out/share/icons/hicolor/128x128/apps/tabby.png \
        tabby.desktop
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

  packages = builtinPlugins ++ ["." "app" "web" "tabby-web-demo"];

  pkgHashes = {
    "." = "sha256-Qklo8iX27lE6VTUAX1bwa9yBw/tMx+G+FB2MJUkt+7s=";
    app = "sha256-wo/ZhfyngBeagoYlzthsUSVNnSTaz+cHZD5dx9X8nP8=";
    web = "sha256-kdER/yB8O7gfWnLZ/rNl4ha1eNnypcVmS1L7RrFCn0Q=";
    tabby-core = "sha256-Z42TZeE0z96ZRtIFIgGbQyv8gtGY/Llya/Dhs8JtuWo=";
    tabby-local = "sha256-GmVoeKxF8Sj55fDPN4GhwGVXoktdiwF3EFYTJHGO/NQ=";
    tabby-settings = "sha256-7t9mXsMqU892fLHyHmivgDxECSVn8KgRNAz9E2nKC/I=";
    tabby-electron = "sha256-JDEsn+7xOcoKFyOCFeClFqcD2NJWwRA6uyM8SwxKW8c=";
    tabby-web-demo = "sha256-i8UoUMb5m+rf/73eKPm2S0v6cs8qSqy6lRjnZ6GoO/k=";
    tabby-linkifier = "sha256-78wgw6BbN/GtRMYeJF9svn9hn82bTZj4+8TXf/rAC64=";
    tabby-web = "sha256-ErhWM0jiVK4PBosBz4IHi1xiemAzRuk/EE8ntyhO2PE=";
    tabby-telnet = "sha256-J8nBBUxwTdigcdohEF6dw8+EHRBUm8O1SLM9oDB3VaA=";
    tabby-ssh = "sha256-8PRf0F6Q3Hoqxiz6lcoFZn0z9EAyeTNNuSh6gli35+U=";
    tabby-community-color-schemes = "sha256-oZgyP0hTU9bxszOVg3Bmiu6yos2d2Inc1Do8To4z8GQ=";
    tabby-plugin-manager = "sha256-CrgsIGg834A+WQh7o07Quv+SSFqYxPMugZsSOHCrdPU=";
    tabby-serial = "sha256-sg/CJnlkUcohFgmY6xGE79WG5mmx9jh196mb8iVCk6g=";
    tabby-terminal = "sha256-LS30V7iqLI0sEm3xlnMFtMnIxhALOMjQ148+zR0NyqU=";
  };

  # Loop through all the packages and create a yarn cache for them
  yarnCaches = map (pkg:
    {
      inherit pkg;
      cache = fetchYarnDeps {
        src = lib.removeSuffix "/." (tabby.src + "/" + pkg);
        sha256 = builtins.getAttr pkg pkgHashes;
      };
    }) packages;

  rebuildPkgs = ["app" "tabby-core" "tabby-local" "tabby-ssh" "tabby-terminal"];

in stdenv.mkDerivation tabby
