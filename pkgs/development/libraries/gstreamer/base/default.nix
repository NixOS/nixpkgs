{ stdenv, fetchurl, pkgconfig, python, gstreamer, gobjectIntrospection
, orc, alsaLib, libXv, pango, libtheora
, cdparanoia, libvisual, libintlOrEmpty
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-base-1.10.3";

  meta = {
    description = "Base plugins and helper libraries";
    homepage = "http://gstreamer.freedesktop.org";
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-base/${name}.tar.xz";
    sha256 = "040pifl4cgsqqz2si4s1y5khj3zwm39w21siagxwp805swbrcag6";
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
