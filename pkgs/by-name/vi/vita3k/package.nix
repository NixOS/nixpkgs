{
  lib,
  appimageTools,
  makeWrapper,
  nix-update-script,
  fetchurl,
}:

appimageTools.wrapType2 rec {
  pname = "vita3k";
  version = "3821";

  src = fetchurl {
    url = "https://github.com/Vita3K/Vita3K-builds/releases/download/${version}/Vita3K-x86_64.AppImage";
    sha256 = "sha256-U2sGt8zHGODes2DB7qK5xJVAhkxyQ6ku/UCmd1D1184=";
  };

  nativeBuildInputs = [ makeWrapper ];

  extraPkgs = pkgs: [ pkgs.sdl3 ];
  extraInstallCommands =
    let
      appimageContents = appimageTools.extract { inherit pname version src; };
    in
    ''
      install -Dm444 ${appimageContents}/vita3k.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/vita3k.desktop \
        --replace-fail "Exec=Vita3K" "Exec=vita3k"
      cp -r ${appimageContents}/usr/share/icons $out/share
      wrapProgram $out/bin/vita3k \
        --set APPIMAGE 1
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Experimental PlayStation Vita emulator";
    homepage = "https://vita3k.org/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ ekisu ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "vita3k";
  };
}
