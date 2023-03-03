{ stdenv
, lib
, fetchFromGitHub
, nix-update-script
, cmake
, ninja
, qtbase
, qtwayland
, qt5
, xorg
, useQt6 ? false
}:

stdenv.mkDerivation rec {
  pname = "adwaita-qt";
  version = "1.4.1";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "FedoraQt";
    repo = pname;
    rev = version;
    sha256 = "sha256-t9vv1KcMUg8Qe7lhVMN4GO+VPoT7QzeoQ6hV4fesA8U=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
  ] ++ lib.optionals stdenv.isLinux [
    xorg.libxcb
  ] ++ lib.optionals (!useQt6) [
    qt5.qtx11extras
  ] ++ lib.optionals useQt6 [
    qtwayland
  ];

  # Qt setup hook complains about missing `wrapQtAppsHook` otherwise.
  dontWrapQtApps = true;

  cmakeFlags = lib.optionals useQt6 [
    "-DUSE_QT6=true"
  ];

  postPatch = ''
    # Fix plugin dir
    substituteInPlace src/style/CMakeLists.txt \
       --replace "DESTINATION \"\''${QT_PLUGINS_DIR}/styles" "DESTINATION \"$qtPluginPrefix/styles"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "A style to bend Qt applications to look like they belong into GNOME Shell";
    homepage = "https://github.com/FedoraQt/adwaita-qt";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members ++ (with maintainers; [ ]);
    platforms = platforms.all;
    broken = stdenv.isDarwin; # broken since 2021-12-05 on hydra, broken until qt515 will be used for darwin
  };
}
