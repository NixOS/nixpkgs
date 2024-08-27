{
  lib,
  buildNpmPackage,
  fetchNpmDeps,
  fetchFromGitHub,
  makeWrapper,
  xmr-btc-swap,
  tor,
  copyDesktopItems,
  makeDesktopItem,
  electron,
}:

buildNpmPackage rec {
  pname = "unstoppableswap";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "UnstoppableSwap";
    repo = "unstoppableswap-gui";
    rev = "v${version}";
    hash = "sha256-WvAecQp+UX9M5U61ddWXzcOUyf/MCUDoG2FyiidMgv0=";
  };

  postPatch = ''
    sed -i -e '/"postinstall"/d' package.json
    sed -i -e "s/BINARIES_PATH, '.*', platform/BINARIES_PATH/g" src/main/cli/dirs.ts
  '';

  npmDepsHash = "sha256-5X59VdeqqDyslMJC3/XwGCTH8mQNbTshR+FsfN3ZJj4=";

  appNpmDeps = fetchNpmDeps {
    inherit src;
    sourceRoot = "${src.name}/release/app";
    hash = "sha256-+If7d9dX8Y9JgeSFh/rUFEpn7v0ZBbGrNjJBRdnPRhk=";
  };

  ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  npmFlags = [ "--legacy-peer-deps" ];

  preInstall = ''
    cd release/app
    npmDeps=${appNpmDeps}
    npmConfigHook
  '';

  desktopItem = makeDesktopItem {
    name = "UnstoppableSwap";
    exec = "UnstoppableSwap %U";
    icon = "UnstoppableSwap";
    desktopName = "UnstoppableSwap";
    categories = [ "Utility" ];
    startupWMClass = "UnstoppableSwap";
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  postInstall = ''
    makeWrapper ${lib.getExe electron} $out/bin/UnstoppableSwap \
      --add-flags $out/lib/node_modules/unstoppableswap-gui/dist/main/main.js

    mkdir -p $out/lib/node_modules/build/bin
    ln -s ${lib.getBin tor}/bin/tor $out/lib/node_modules/build/bin/tor
    ln -s ${lib.getBin xmr-btc-swap}/bin/swap $out/lib/node_modules/build/bin/swap

    install -Dm444 ../../assets/icons/512x512.png $out/share/icons/hicolor/512x512/apps/UnstoppableSwap.png
  '';

  meta = {
    description = "XMR<>BTC Atomic Swaps GUI";
    homepage = "https://github.com/UnstoppableSwap/unstoppableswap-gui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ linsui ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "UnstoppableSwap";
  };
}
