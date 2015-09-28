{ stdenv, fetchurl, xlibsWrapper, libjpeg, libtiff, giflib, libpng, bzip2, pkgconfig }:

stdenv.mkDerivation rec {
  name = "imlib2-1.4.6";

  src = fetchurl {
    url = "mirror://sourceforge/enlightenment/${name}.tar.bz2";
    sha256 = "0x1j0ylpclkp8cfpwfpkjywqz124bqskyxbw8pvwzkv2gmrbwldg";
  };

  buildInputs = [ xlibsWrapper libjpeg libtiff giflib libpng bzip2 ];

  nativeBuildInputs = [ pkgconfig ];

  # From
  # https://github.com/PhantomX/slackbuilds/blob/master/imlib2/patches/imlib2-giflib51.patch
  patches = [ ./giflib51.patch ];

  preConfigure = ''
    substituteInPlace imlib2-config.in \
      --replace "@my_libs@" ""
  '';

  # Do not build amd64 assembly code on Darwin, because it fails to compile
  # with unknow directive errors
  configureFlags = if stdenv.isDarwin then [ "--enable-amd64=no" ] else null;

  meta = {
    description = "Image manipulation library";

    longDescription = ''
      This is the Imlib 2 library - a library that does image file loading and
      saving as well as rendering, manipulation, arbitrary polygon support, etc.
      It does ALL of these operations FAST. Imlib2 also tries to be highly
      intelligent about doing them, so writing naive programs can be done
      easily, without sacrificing speed.
    '';

    license = stdenv.lib.licenses.free;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ spwhitt ];
  };
}
