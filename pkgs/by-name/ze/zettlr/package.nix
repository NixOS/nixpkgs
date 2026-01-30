{
  appimageTools,
  lib,
  fetchurl,
  makeWrapper,
  nix-update-script,
}:

# Based on https://gist.github.com/msteen/96cb7df66a359b827497c5269ccbbf94 and joplin-desktop nixpkgs.
let
  pname = "zettlr";
  version = "4.1.0";

  src = fetchurl {
    url = "https://github.com/Zettlr/Zettlr/releases/download/v${version}/Zettlr-${version}-x86_64.appimage";
    hash = "sha256-/6x2HhwW0+A7/CYC+HUCsJ2u1tp4zno6XjpvBLogUKU=";
  };
  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 rec {
  inherit pname version src;

  extraPkgs = pkgs: [
    pkgs.texliveMedium
    pkgs.pandoc
  ];

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    wrapProgram $out/bin/zettlr \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
    install -m 444 -D ${appimageContents}/Zettlr.desktop $out/share/applications/Zettlr.desktop
    install -m 444 -D ${appimageContents}/Zettlr.png $out/share/icons/hicolor/512x512/apps/Zettlr.png
    substituteInPlace $out/share/applications/Zettlr.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Markdown editor for writing academic texts and taking notes";
    homepage = "https://www.zettlr.com";
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ maj0e ];
    license = lib.licenses.gpl3;
    mainProgram = "zettlr";
  };
}
