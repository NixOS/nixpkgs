{
  stdenv,
  fetchzip,
  fetchurl,
  lib,
  makeWrapper,
  electron,
  imagemagick,
  makeDesktopItem,
  autoPatchelfHook,
}:
let
  inherit (stdenv.hostPlatform) system;
  pname = "twinejs";
  version = "2.11.1";
  meta = {
    description = "Twine, a tool for telling interactive, nonlinear stories";
    homepage = "https://twinery.org";
    downloadPage = "https://github.com/klembot/twinejs/releases/tag/2.11.1";
    mainProgram = "obsidian";
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
  desktopItem = makeDesktopItem {
    name = "twinejs";
    desktopName = "Twine";
    comment = "";
    icon = "twinejs";
    exec = "twinejs %u";
  };

in
stdenv.mkDerivation {
  inherit
    pname
    version
    src
    desktopItem
    icon
    meta
    ;

  nativeBuildInputs = [
    makeWrapper
    imagemagick
    autoPatchelfHook
  ];
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    makeWrapper ${electron}/bin/electron $out/bin/twinejs \
      --add-flags $out/share/twinejs/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-wayland-ime=true --wayland-text-input-version=3}}"
    install -m 444 -D resources/app.asar $out/share/twinejs/app.asar
    install -m 444 -D "${desktopItem}/share/applications/"* \
      -t $out/share/applications/
    for size in 16 24 32 48 64 128 256 512; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      magick -background none ${icon} -resize "$size"x"$size" $out/share/icons/hicolor/"$size"x"$size"/apps/twinejs.png
    done
    runHook postInstall
  '';
}
