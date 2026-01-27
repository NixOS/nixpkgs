{
  stdenv,
  fetchzip,
  fetchurl,
  lib,
  makeWrapper,
  electron,
  makeDesktopItem,
  copyDesktopItems,
  autoPatchelfHook,
}:
let
  inherit (stdenv.hostPlatform) system;
  pname = "twinejs";
  version = "2.11.1";
  comment = "Tool for telling interactive, nonlinear stories";
  meta = {
    description = comment;
    homepage = "https://twinery.org";
    downloadPage = "https://github.com/klembot/twinejs/releases/tag/2.11.1";
    mainProgram = "twinejs";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ mcparland ];
  };
  downloadsByArch =
    {
      "x86_64-linux" = {
        filename = "Linux-x64";
        hash = "sha256-HcpVOcQ/lWTLeAgTF+1xPj41HO+wC4au8SEJGC0Nm1Q=";
      };
      "aarch64-linux" = {
        filename = "Linux-arm64";
        hash = "sha256-B6pIAnjznOvkyS7fNSZ+VbvOj77+pn3YPkxDcgfrw5Y=";
      };
    }
    .${system};
  src = fetchzip {
    url = "https://github.com/klembot/twinejs/releases/download/${version}/Twine-${version}-${downloadsByArch.filename}.zip";
    hash = downloadsByArch.hash;
    stripRoot = false;
  };
  icon = fetchurl {
    url = "https://github.com/klembot/twinejs/raw/refs/heads/develop/icons/logo.svg";
    hash = "sha256-TwxXOX/ZbrH02ZzTpy0FB4nGhjLmjtkFrE7WEX7xHbw=";
  };
  desktopItems = [
    (makeDesktopItem {
      inherit comment;
      name = "twinejs";
      desktopName = "Twine";
      icon = "twinejs";
      exec = "twinejs %u";
      terminal = false;
    })
  ];

in
stdenv.mkDerivation {
  inherit
    pname
    version
    src
    desktopItems
    icon
    meta
    ;

  nativeBuildInputs = [
    makeWrapper
    autoPatchelfHook
    copyDesktopItems
  ];
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    makeWrapper ${electron}/bin/electron $out/bin/twinejs \
      --add-flags $out/share/twinejs/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-wayland-ime=true --wayland-text-input-version=3}}"
    install -m 444 -D resources/app.asar $out/share/twinejs/app.asar
    install -m 444 -D ${icon} $out/share/icons/hicolor/scalable/apps/twinejs.svg
    runHook postInstall
  '';
}
