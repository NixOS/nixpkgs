{
  lib,
  fetchurl,
  makeWrapper,
  appimageTools,
}:

let
  pname = "zettlr";
  version = "3.5.0";

  src = fetchurl {
    url = "https://github.com/Zettlr/Zettlr/releases/download/v${version}/Zettlr-${version}-x86_64.appimage";
    hash = "sha256-cOki3RmcNxhPCOZN+RZoowmPp0fpO2fRdT21G2ooqKo=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
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

  meta = {
    description = "Markdown editor for writing academic texts and taking notes";
    homepage = "https://www.zettlr.com";
    changelog = "https://github.com/Zettlr/Zettlr/releases";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ tfmoraes ];
    mainProgram = "zettlr";
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
  };
}
