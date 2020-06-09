{ mkDerivation, lib, fetchFromGitHub, cmake, ninja, qtbase, pantheon }:

mkDerivation rec {
  pname = "adwaita-qt";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "FedoraQt";
    repo = pname;
    rev = version;
    sha256 = "1zfah1ybfgi4dag3lxqap99giwwng9b3lgcick1ciylz6vwf2gwh";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
  ];

  postPatch = ''
    # Fix plugin dir
    substituteInPlace style/CMakeLists.txt \
       --replace "DESTINATION \"\''${QT_PLUGINS_DIR}/styles" "DESTINATION \"$qtPluginPrefix/styles"
  '';

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "A style to bend Qt applications to look like they belong into GNOME Shell";
    homepage = "https://github.com/FedoraQt/adwaita-qt";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.linux;
  };
}
