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
  glib,
}:
let
  inherit (stdenv.hostPlatform) system;
  pname = "twinejs";
  version = "2.11.1";
  comment = "Tool for telling interactive, nonlinear stories";
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

  mkChangelog =
    version:
    let
      xs = lib.splitVersion version;
    in
    "https://twinery.org/reference/en/release-notes/${lib.concatStringsSep "-" (lib.take 2 xs)}.html#${lib.concatStrings xs}";
in
stdenv.mkDerivation (finalAttrs: {
  inherit
    pname
    version
    src
    desktopItems
    icon
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
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-wayland-ime=true --wayland-text-input-version=3}}" \
      --prefix PATH : ${
        lib.makeBinPath [
          glib # `gio` is required to move items to trash (e.g. when deleting a story)
        ]
      }
    install -m 444 -D resources/app.asar $out/share/twinejs/app.asar
    install -m 444 -D ${icon} $out/share/icons/hicolor/scalable/apps/twinejs.svg
    runHook postInstall
  '';

  meta = {
    description = comment;
    homepage = "https://twinery.org";
    downloadPage = "https://github.com/klembot/twinejs/releases/tag/${finalAttrs.version}";
    changelog = mkChangelog finalAttrs.version;
    mainProgram = "twinejs";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ mcparland ];
  };
})
