{ stdenv, fetchurl, cmake, automoc4, qt4, pkgconfig, phonon, gst_all_1 }:

let
  version = "4.8.2";
  pname = "phonon-backend-gstreamer";
in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/phonon/${pname}/${version}/src/${name}.tar.xz";
    sha256 = "1q1ix6zsfnh6gfnpmwp67s376m7g7ahpjl1qp2fqakzb5cgzgq10";
  };

  buildInputs = with gst_all_1; [ phonon qt4 gstreamer gst-plugins-base ];

  nativeBuildInputs = [ cmake automoc4 pkgconfig ];

  NIX_CFLAGS_COMPILE = [
    # This flag should be picked up through pkgconfig, but it isn't.
    "-I${gst_all_1.gstreamer}/lib/gstreamer-1.0/include"
  ];

  cmakeFlags = [ "-DCMAKE_INSTALL_LIBDIR=lib" ];

  meta = {
    homepage = http://phonon.kde.org/;
    description = "GStreamer backend for Phonon";
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ ttuegel ];
  };
}
