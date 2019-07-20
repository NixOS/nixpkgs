{ stdenv, fetchurl, autoconf, automake, libtool, pkgconfig
, freetype, SDL, libX11 }:

stdenv.mkDerivation rec {
  name = "agg-2.5";
  src = fetchurl {
    url = "http://www.antigrain.com/${name}.tar.gz";
    sha256 = "07wii4i824vy9qsvjsgqxppgqmfdxq0xa87i5yk53fijriadq7mb";
  };
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ autoconf automake libtool freetype SDL libX11 ];

  # fix build with new automake, from Gentoo ebuild
  preConfigure = ''
    sed -i '/^AM_C_PROTOTYPES/d' configure.in
    sh autogen.sh
  '';

  configureFlags = [ "--x-includes=${libX11.dev}/include" "--x-libraries=${libX11.out}/lib" "--enable-examples=no" ];

  # libtool --tag=CXX --mode=link g++ -g -O2 libexamples.la ../src/platform/X11/libaggplatformX11.la ../src/libagg.la -o alpha_mask2 alpha_mask2.o
  # libtool: error: cannot find the library 'libexamples.la'
  enableParallelBuilding = false;

  meta = {
    description = "High quality rendering engine for C++";

    longDescription = ''
      Anti-Grain Geometry (AGG) is an Open Source, free of charge
      graphic library, written in industrially standard C++.  The
      terms and conditions of use AGG are described on The License
      page.  AGG doesn't depend on any graphic API or technology.
      Basically, you can think of AGG as of a rendering engine that
      produces pixel images in memory from some vectorial data.  But
      of course, AGG can do much more than that.
    '';

    license = stdenv.lib.licenses.gpl2Plus;
    homepage = http://www.antigrain.com/;
    platforms = stdenv.lib.platforms.linux;
  };
}
