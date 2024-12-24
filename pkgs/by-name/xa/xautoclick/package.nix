{
  lib,
  stdenv,
  fetchFromGitHub,
  xorg,
  pkg-config,
  cmake,
  libevdev,
  gtkSupport ? true,
  gtk3,
  pcre,
  glib,
  wrapGAppsHook3,
  fltkSupport ? true,
  fltk,
  qtSupport ? true,
  qt5,
}:

stdenv.mkDerivation rec {
  pname = "xautoclick";
  version = "0.34";

  src = fetchFromGitHub {
    owner = "qarkai";
    repo = "xautoclick";
    rev = "v${version}";
    sha256 = "GN3zI5LQnVmRC0KWffzUTHKrxcqnstiL55hopwTTwpE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs =
    [
      libevdev
      xorg.libXtst
    ]
    ++ lib.optionals gtkSupport [
      gtk3
      pcre
      glib
      wrapGAppsHook3
    ]
    ++ lib.optionals fltkSupport [ fltk ]
    ++ lib.optionals qtSupport [
      qt5.qtbase
      qt5.wrapQtAppsHook
    ];

  meta = with lib; {
    description = "Autoclicker application, which enables you to automatically click the left mousebutton";
    homepage = "https://github.com/qarkai/xautoclick";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
