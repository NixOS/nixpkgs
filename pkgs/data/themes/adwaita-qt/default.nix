{ mkDerivation
, stdenv
, lib
, fetchFromGitHub
, nix-update-script
, cmake
, ninja
, qtbase
, qt5
, xorg
}:

mkDerivation rec {
  pname = "adwaita-qt";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "FedoraQt";
    repo = pname;
    rev = version;
    sha256 = "1fkivdiz4al84nhgg1srj33l109j9si63biw3asy339cyyzj28c9";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
    qt5.qtx11extras
  ] ++ lib.optionals stdenv.isLinux [
    xorg.libxcb
  ];

  postPatch = ''
    # Fix plugin dir
    substituteInPlace src/style/CMakeLists.txt \
       --replace "DESTINATION \"\''${QT_PLUGINS_DIR}/styles" "DESTINATION \"$qtPluginPrefix/styles"
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "A style to bend Qt applications to look like they belong into GNOME Shell";
    homepage = "https://github.com/FedoraQt/adwaita-qt";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members ++ (with maintainers; [ ]);
    platforms = platforms.all;
  };
}
