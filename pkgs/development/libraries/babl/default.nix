{ stdenv
, fetchurl
, meson
, ninja
, pkgconfig
, gobject-introspection
, lcms2
}:

stdenv.mkDerivation rec {
  pname = "babl";
  version = "0.1.74";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://download.gimp.org/pub/babl/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "03nfcvy3453xkfvsfcnsfcjf2vg2pin09qnr9jlssdysa1lhnwcs";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    gobject-introspection
  ];

  buildInputs = [
    lcms2
  ];

  meta = with stdenv.lib; {
    description = "Image pixel format conversion library";
    homepage = http://gegl.org/babl/;
    license = licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
