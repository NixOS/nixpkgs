{ stdenv, fetchurl, pkgconfig, python, gstreamer, gobjectIntrospection
, orc, alsaLib, libXv, pango, libtheora
, cdparanoia, libvisual, libintlOrEmpty
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-base-1.14.0";

  meta = {
    description = "Base plugins and helper libraries";
    homepage = https://gstreamer.freedesktop.org;
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-base/${name}.tar.xz";
    sha256 = "0h39bcp7fcd9kgb189lxr8l0hm0almvzpzgpdh1jpq2nzxh4d43y";
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
