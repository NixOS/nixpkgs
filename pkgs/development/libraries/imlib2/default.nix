{ stdenv, fetchurl, libjpeg, libtiff, giflib, libpng, bzip2, pkgconfig
, freetype, libid3tag
, x11Support ? true, xlibsWrapper ? null }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "imlib2-1.5.1";

  src = fetchurl {
    url = "mirror://sourceforge/enlightenment/${name}.tar.bz2";
    sha256 = "1bms2iwmvnvpz5jqq3r52glarqkafif47zbh1ykz8hw85d2mfkps";
  };

  buildInputs = [ libjpeg libtiff giflib libpng bzip2 freetype libid3tag ]
    ++ optional x11Support xlibsWrapper;

  nativeBuildInputs = [ pkgconfig ];

  enableParallelBuilding = true;

  preConfigure = ''
    substituteInPlace imlib2-config.in \
      --replace "@my_libs@" ""
  '';

  # Do not build amd64 assembly code on Darwin, because it fails to compile
  # with unknow directive errors
  configureFlags = optional stdenv.isDarwin "--enable-amd64=no"
    ++ optional (!x11Support) "--without-x";

  outputs = [ "bin" "out" "dev" ];

  postInstall = ''
    moveToOutput bin/imlib2-config "$dev"
  '';

  meta = {
    description = "Image manipulation library";

    longDescription = ''
      This is the Imlib 2 library - a library that does image file loading and
      saving as well as rendering, manipulation, arbitrary polygon support, etc.
      It does ALL of these operations FAST. Imlib2 also tries to be highly
      intelligent about doing them, so writing naive programs can be done
      easily, without sacrificing speed.
    '';

    homepage = http://docs.enlightenment.org/api/imlib2/html;
    license = licenses.free;
    platforms = platforms.unix;
    maintainers = with maintainers; [ spwhitt ];
  };
}
