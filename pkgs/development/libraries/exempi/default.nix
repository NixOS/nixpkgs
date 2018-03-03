{ stdenv, fetchurl, expat, zlib, boost, libiconv, darwin }:

stdenv.mkDerivation rec {
  name = "exempi-2.4.4";

  src = fetchurl {
    url = "http://libopenraw.freedesktop.org/download/${name}.tar.bz2";
    sha256 = "1c1xxiw9lazdaz4zvrnvcy9pif9l1wib7zy91m48i7a4bnf9mmd2";
  };

  configureFlags = [
    "--with-boost=${boost.dev}"
  ];

  buildInputs = [ expat zlib boost ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv darwin.apple_sdk.frameworks.CoreServices ];

  meta = with stdenv.lib; {
    homepage = https://libopenraw.freedesktop.org/wiki/Exempi/;
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.bsd3;
  };
}
