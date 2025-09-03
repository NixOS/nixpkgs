{
  lib,
  stdenv,

  fetchFromGitHub,
  fetchYarnDeps,

  copyDesktopItems,
  fixup-yarn-lock,
  makeBinaryWrapper,
  makeDesktopItem,
  replaceVars,
  writableTmpDirAsHomeHook,

  fontconfig,
  pkg-config,
  libsecret,

  electron_37,
  http-server,
  jq,
  moreutils,
  nodejs,
  patch-package,
  python3,
  yarn,
}:

let
  version = "1.0.227";

  src = fetchFromGitHub {
    owner = "Eugeny";
    repo = "tabby";
    tag = "v${version}";
    hash = "sha256-F8x+f5f+IQ8YpwYRKmtnegilMGwRRGt+e4sjFFfjGu0=";
  };

  pkgHashes = lib.importJSON ./pkg-hashes.json;

  packages = lib.attrNames pkgHashes;
  builtinPlugins = lib.filter (lib.hasPrefix "tabby-") packages;

  yarnCaches = map (pkg: {
    inherit pkg;
    cache = fetchYarnDeps {
      name = "offline-${pkg}";
      src = lib.removeSuffix "/." (src + "/" + pkg);
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

  electron = electron_37;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "tabby-terminal";
  inherit version src;

  patches = [
    ./splice-argv.patch
    (replaceVars ./use-nix-version.patch { inherit version; })
  ];

  postPatch = ''
    jq '.version = "${version}"' app/package.json | sponge app/package.json
  '';

  buildInputs = [
    libsecret
  ];

  nativeBuildInputs = [
    copyDesktopItems
    electron
    fixup-yarn-lock
    fontconfig
    http-server
    jq
    makeBinaryWrapper
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
    writableTmpDirAsHomeHook
    yarn
  ];

  configurePhase = ''
    runHook preConfigure

  ''
  # Loop through all the yarn caches and install the deps for the respective package
  + lib.concatMapStringsSep "\n" (cache: ''
    pushd ${cache.pkg}
      fixup-yarn-lock yarn.lock
      yarn config --offline set yarn-offline-mirror ${cache.cache}
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
  '') yarnCaches
  + ''
    pushd node_modules
  ''
  # Loop through the "built in" plugins and link them to the node_modules
  + lib.concatMapStringsSep "\n" (plugin: ''
    ln -fs ../${plugin} ${plugin}
  '') builtinPlugins
  + ''
    popd

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
    '') rebuildPkgs
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

  passthru = {
    updateScript = ./update.sh;
  };

  meta = {
    description = "Terminal for a more modern age";
    homepage = "https://tabby.sh";
    license = lib.licenses.mit;
    mainProgram = "tabby";
    maintainers = with lib.maintainers; [ geodic ];
    platforms = lib.platforms.linux;
  };
})
