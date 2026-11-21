{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  libsecret,
  python3,
  makeShellWrapper,
  copyDesktopItems,
  makeDesktopItem,
  imagemagick,
  removeReferencesTo,
  electron,
}:

let
  pythonEnv = python3.withPackages (ps: [ ps.setuptools ]);
in
buildNpmPackage (finalAttrs: {
  pname = "zequel";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "zequel-labs";
    repo = "zequel";
    tag = "${finalAttrs.version}";
    hash = "sha256-0L4OyNddRYKI/7BR3TjcAtO2zzWn1pByKwSIypYy/eo=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  patches = [
    # Upstream better-sqlite3 11.x uses outdated V8 C++ APIs that fail to compile
    # against modern Electron headers (V8 pointer sandboxing). Bumping to 13.x
    # switches to ABI-stable Node-API.
    ./bump-better-sqlite3.patch
  ];

  npmDepsHash = "sha256-RF0i/eV4Mf+N5Qz25TEt9U4GMX5pimpZUxQp13Oo19I=";

  nativeBuildInputs = [
    pkg-config
    pythonEnv
    makeShellWrapper
    copyDesktopItems
    imagemagick
    removeReferencesTo
  ];

  buildInputs = [
    libsecret
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    PYTHON = "${pythonEnv}/bin/python3";
  };

  preBuild = ''
    # Rebuild better-sqlite3 against Electron headers
    pushd node_modules/better-sqlite3
    rm -rf prebuilds
    npm run build-release --offline --nodedir="${electron.headers}"
    rm -rf build/Release/{.deps,obj,obj.target,test_extension.node}
    find build -type f -exec ${lib.getExe removeReferencesTo} -t "${electron.headers}" {} +
    popd
  '';

  dontNpmInstall = true;

  installPhase = ''
    runHook preInstall

    npm prune --production

    mkdir -p $out/share/zequel
    cp -r out node_modules package.json resources $out/share/zequel/

    for size in 16 24 32 48 64 128 256 512; do
      mkdir -p "$out/share/icons/hicolor/''${size}x''${size}/apps"
      magick resources/icon-1024.png -resize "''${size}x''${size}" "$out/share/icons/hicolor/''${size}x''${size}/apps/zequel.png"
    done
    install -Dm644 resources/icon-1024.png "$out/share/icons/hicolor/1024x1024/apps/zequel.png"
    install -Dm644 resources/icon-1024.png "$out/share/pixmaps/zequel.png"

    makeShellWrapper ${lib.getExe electron} $out/bin/zequel \
      --inherit-argv0 \
      --add-flags $out/share/zequel \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime}}" \
      --set-default NODE_ENV production \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libsecret
          stdenv.cc.cc.lib
        ]
      }

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "zequel";
      exec = "zequel %U";
      icon = "zequel";
      desktopName = "Zequel";
      comment = finalAttrs.meta.description;
      categories = [
        "Development"
        "Database"
      ];
    })
  ];

  meta = {
    description = "Modern, open-source database management GUI";
    homepage = "https://github.com/zequel-labs/zequel";
    license = lib.licenses.elastic20;
    maintainers = with lib.maintainers; [ aliheidary1381 ];
    mainProgram = "zequel";
    platforms = electron.meta.platforms;
  };
})
