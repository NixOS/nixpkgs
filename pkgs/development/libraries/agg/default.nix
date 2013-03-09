{ stdenv, fetchurl, autoconf, automake, libtool, pkgconfig
, freetype, SDL, libX11 }:

stdenv.mkDerivation rec {
  name = "agg-2.5";
  src = fetchurl {
    url = "http://www.antigrain.com/${name}.tar.gz";
    sha256 = "07wii4i824vy9qsvjsgqxppgqmfdxq0xa87i5yk53fijriadq7mb";
  };
  buildInputs = [ autoconf automake libtool pkgconfig freetype SDL libX11 ];

  # fix build with new automake, from Gentoo ebuild
  preConfigure = ''
    sed -i '/^AM_C_PROTOTYPES/d' configure.in
    sh autogen.sh
  '';

  configureFlags = "--x-includes=${libX11}/include --x-libraries=${libX11}/lib";

  meta = {
    description = "The Anti-Grain Geometry (AGG) library, a high quality rendering engine for C++";

    longDescription = ''
      Anti-Grain Geometry (AGG) is an Open Source, free of charge
      graphic library, written in industrially standard C++.  The
      terms and conditions of use AGG are described on The License
      page.  AGG doesn't depend on any graphic API or technology.
      Basically, you can think of AGG as of a rendering engine that
      produces pixel images in memory from some vectorial data.  But
      of course, AGG can do much more than that.
    '';

    license = "GPLv2+";
    homepage = http://www.antigrain.com/;
  };
}
