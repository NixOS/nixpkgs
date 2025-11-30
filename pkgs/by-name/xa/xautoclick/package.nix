{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    (fetchpatch {
      name = "bump-cmake-required-version.patch";
      url = "https://github.com/qarkai/xautoclick/commit/a6cd4058fa7d8579bf4ada3f48441f333fca9dab.patch?full_index=1";
      hash = "sha256-4ovcaVrXQqFZX85SnewtfjZpipcGTw52ZrTkT6iWZQM=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
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
