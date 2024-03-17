{ lib
, buildNpmPackage
, fetchNpmDeps
, fetchFromGitHub
, makeWrapper
, xmr-btc-swap
, tor
, copyDesktopItems
, makeDesktopItem
, electron
}:

buildNpmPackage rec {
  pname = "unstoppableswap";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "UnstoppableSwap";
    repo = "unstoppableswap-gui";
    rev = "v${version}";
    hash = "sha256-5b7cKevDJcs0EJN1csboYacJM9Ea/uJdDowfSyrEE5c=";
  };

  postPatch = ''
    sed -i -e '/"postinstall"/d' package.json
    sed -i -e "s/BINARIES_PATH, '.*', platform/BINARIES_PATH/g" src/main/cli/dirs.ts
  '';

  npmDepsHash = "sha256-qAD+WxEXilJ/+eWG2395hW4oPBqR8WIoY7B8cjDRfVA=";

  appNpmDeps = fetchNpmDeps {
    inherit src;
    sourceRoot = "${src.name}/release/app";
    hash = "sha256-UZ9uhB08yNmr0PXpMJO3Wm6ZEAltD/v3tUNwxrJ43w4=";
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
    comment = "A modern GUI video and audio downloader";
    categories = [ "Utility" ];
    startupWMClass = "UnstoppableSwap";
  };

  nativeBuildInputs = [ makeWrapper copyDesktopItems ];

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
    platforms = lib.platforms.all;
    mainProgram = "UnstoppableSwap";
  };
}
