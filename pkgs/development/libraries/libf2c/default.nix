{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "libf2c-20100903";

  src = fetchurl {
    url = http://www.netlib.org/f2c/libf2c.zip;
    sha256 = "1mcp1lh7gay7hm186dr0wvwd2bc05xydhnc1qy3dqs4n3r102g7i";
  };

  unpackPhase = ''
    mkdir build
    cd build
    unzip ${src}
  '';

  makeFlags = "-f makefile.u";

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
