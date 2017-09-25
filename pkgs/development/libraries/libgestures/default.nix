{ stdenv, fetchgit, fetchFromGitHub, glib, jsoncpp, pkgconfig }:

stdenv.mkDerivation {
  name = "libgestures-2016-05-20";

  src = fetchFromGitHub {
    owner = "GalliumOS";
    repo = "libgestures";
    rev = "3b6a3558ea390d345022ace5b187a7212f041d86";
    sha256 = "1nxr3nxf2kzp90lqbhx2qmb52yxgd7q5ds8yzi4hll91wcx8by6l";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib jsoncpp ];

  preConfigure = ''
    sed -i "1i#include <cmath>" include/gestures/include/finger_metrics.h
    substituteInPlace Makefile --replace /usr/include include
  '';

  installPhase = ''
    make DESTDIR=$out/ LIBDIR=lib install
  '';
}
