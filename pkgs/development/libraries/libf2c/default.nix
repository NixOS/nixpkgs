{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "libf2c-20160102";

  src = fetchurl {
    url = http://www.netlib.org/f2c/libf2c.zip;
    sha256 = "1q78y8j8xpl8zdzdxmn5ablss56hi5a7vz3idam9l2nfx5q40h6a";
  };

  unpackPhase = ''
    mkdir build
    cd build
    unzip ${src}
  '';

  makeFlags = [ "-f" "makefile.u" ];

  installPhase = ''
    mkdir -p $out/include $out/lib
    cp libf2c.a $out/lib
    cp f2c.h $out/include
  '';

  buildInputs = [ unzip ];

  hardeningDisable = [ "format" ];

  meta = {
    description = "F2c converts Fortran 77 source code to C";
    homepage = http://www.netlib.org/f2c/;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.unix;
  };
}
