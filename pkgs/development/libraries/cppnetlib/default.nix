{stdenv, fetchurl, cmake, openssl, boost}:

stdenv.mkDerivation rec {
  name = "cpp-netlib-0.9.2";

  src = fetchurl {
    url = "https://github.com/downloads/cpp-netlib/cpp-netlib/${name}.tar.bz2";
    sha256 = "0llmiyp9l7byavwdyb7vpks27yfv3g85170bm81paps748bcyb1p";
  };

  buildInputs = [ cmake boost openssl ];

  /* Tests fail to build ...
    https://github.com/cpp-netlib/cpp-netlib/issues/85

    Once working, we could do:
    checkTarget = "test";
    doCheck = true;
  */

  preConfigure = ''
    sed -i /test/d CMakeLists.txt
  '';

  /* The build phase just builds examples. That's at least some testing.
     That's how to install the lib - copy the headers. */
  installPhase = ''
    # We are at sourcepath/build
    mkdir -p $out/include
    cp -R ../boost $out/include/
    mkdir -p $out/lib
    cp -R libs/network/src/*.a $out/lib/
  '';

  meta = {
    homepage = http://cpp-netlib.github.com/;
    description = "Provides application layer network support at boost style";
    license = "boost";
  };
}
