{stdenv, fetchurl, zlib, libpng, freetype, libjpeg, fontconfig}:

stdenv.mkDerivation {
  name = "gd-2.0.35";

  src = fetchurl {
    url = http://www.libgd.org/releases/gd-2.0.35.tar.bz2;
    sha256 = "1y80lcmb8qbzf0a28841zxhq9ndfapmh2fsrqfd9lalxfj8288mz";
  };

  buildInputs = [zlib libpng freetype];

  propagatedBuildInputs = [libjpeg fontconfig]; # urgh

  hardeningDisable = [ "format" ];

  configureFlags = "--without-x";

  meta = {
    homepage = http://www.libgd.org/;
    description = "An open source code library for the dynamic creation of images by programmers";
  };
}
