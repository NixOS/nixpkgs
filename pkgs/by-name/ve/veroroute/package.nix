{
  lib,
  stdenv,
  fetchsvn,
  qt5,
}:

let
  inherit (qt5) qmake wrapQtAppsHook;
in
stdenv.mkDerivation {
  pname = "veroroute";
  version = "2.39";

  src = fetchsvn {
    url = "https://svn.code.sf.net/p/veroroute/code/trunk";
    rev = "660";
    hash = "sha256-5H1eU0ymzsFUShpAEAebGM2eRhKqeZPCzW60W24WG64=";
  };

  qmakeFlags = [ "src/veroroute.pro" ];

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
  ];

  postInstall = ''
    mkdir $out/bin
    install -Dm755 veroroute $out/bin
  '';

  meta = {
    homepage = "https://sourceforge.net/projects/veroroute/";
    description = "Qt based electronics layout and routing application";
    longDescription = ''
      Qt based Veroboard, Perfboard, and PCB layout and routing application
    '';
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    mainProgram = "veroroute";
    maintainers = with lib.maintainers; [ gm6k ];
  };
}
