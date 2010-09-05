{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "icu4c-4.5.1";
  
  src = fetchurl {
    url = http://download.icu-project.org/files/icu4c/4.5.1/icu4c-4_5_1-src.tgz;
    sha256 = "1cbjwz99rqy6r3rb3022qlcrfvncvgigpb7n9824jadz9m17lmfm";
  };

  patchFlags = "-p0";

  CFLAGS = "-O0";
  CXXFLAGS = "-O0";

  postUnpack = "
    sourceRoot=\${sourceRoot}/source
    echo Source root reset to \${sourceRoot}
  ";
  
  configureFlags = "--disable-debug";

  meta = {
    description = "Unicode and globalization support library";
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.all;
  };
}
