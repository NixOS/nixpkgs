{ stdenv
, lib
, fetchFromGitHub
, cmake
, qttools
, pkg-config
, wrapQtAppsHook
, qtbase
, qtsvg
, dtkwidget
, qt5integration
, qt5platform-plugins
}:

stdenv.mkDerivation rec {
  pname = "deepin-draw";
  version = "7.0.2";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-WeubXsshN4tUlIwEHTxHXv1L2dvJ2DZ6qtSPyiVtc98=";
  };

  postPatch = ''
    substituteInPlace com.deepin.Draw.service \
      --replace "/usr/bin/deepin-draw" "$out/bin/deepin-draw"
  '';

  nativeBuildInputs = [
    cmake
    qttools
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qt5integration
    qtsvg
    dtkwidget
    qt5platform-plugins
  ];

  cmakeFlags = [ "-DVERSION=${version}" ];

  strictDeps = true;

  meta = {
    description = "Lightweight drawing tool for users to freely draw and simply edit images";
    mainProgram = "deepin-draw";
    homepage = "https://github.com/linuxdeepin/deepin-draw";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.deepin.members;
  };
}
