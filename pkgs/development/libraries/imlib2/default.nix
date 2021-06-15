{ lib, stdenv, fetchurl
# Image file formats
, libjpeg, libtiff, giflib, libpng, libwebp
# imlib2 can load images from ID3 tags.
, libid3tag
, freetype , bzip2, pkg-config
, x11Support ? true, xlibsWrapper ? null
}:

let
  inherit (lib) optional;
in
stdenv.mkDerivation rec {
  pname = "imlib2";
  version = "1.7.1";

  src = fetchurl {
    url = "mirror://sourceforge/enlightenment/${pname}-${version}.tar.bz2";
    sha256 = "sha256-AzpqY53LyOA/Zf8F5XBo5zRtUO4vL/8wS7kJWhsrxAc=";
  };

  buildInputs = [
    libjpeg libtiff giflib libpng libwebp
    bzip2 freetype libid3tag
  ] ++ optional x11Support xlibsWrapper;

  nativeBuildInputs = [ pkg-config ];

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

  meta = with lib; {
    description = "Image manipulation library";

    longDescription = ''
      This is the Imlib 2 library - a library that does image file loading and
      saving as well as rendering, manipulation, arbitrary polygon support, etc.
      It does ALL of these operations FAST. Imlib2 also tries to be highly
      intelligent about doing them, so writing naive programs can be done
      easily, without sacrificing speed.
    '';

    homepage = "https://docs.enlightenment.org/api/imlib2/html";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ spwhitt ];
  };
}
