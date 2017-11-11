{ stdenv, fetchurl, pkgconfig, python, gstreamer, gobjectIntrospection
, orc, alsaLib, libXv, pango, libtheora
, cdparanoia, libvisual, libintlOrEmpty
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-base-1.12.2";

  meta = {
    description = "Base plugins and helper libraries";
    homepage = https://gstreamer.freedesktop.org;
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-base/${name}.tar.xz";
    sha256 = "0x86a7aph0y6gyq178plvwvbbyhkfb3hf0gadx9sk5z1mzixqrsh";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    pkgconfig python gobjectIntrospection
  ];

  buildInputs = [
    orc libXv pango libtheora cdparanoia
  ]
  ++ libintlOrEmpty
  ++ stdenv.lib.optional stdenv.isLinux alsaLib
  ++ stdenv.lib.optional (!stdenv.isDarwin) libvisual;

  propagatedBuildInputs = [ gstreamer ];

  configureFlags = if stdenv.isDarwin then [
    # Does not currently build on Darwin
    "--disable-libvisual"
    # Undefined symbols _cdda_identify and _cdda_identify_scsi in cdparanoia
    "--disable-cdparanoia"
  ] else null;

  NIX_LDFLAGS = if stdenv.isDarwin then "-lintl" else null;

  enableParallelBuilding = true;
}
