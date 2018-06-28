{ stdenv, fetchurl, expat, zlib, boost, libiconv, darwin }:

stdenv.mkDerivation rec {
  name = "exempi-2.4.5";

  src = fetchurl {
    url = "https://libopenraw.freedesktop.org/download/${name}.tar.bz2";
    sha256 = "07i29xmg8bqriviaf4vi1mwha4lrw85kfla29cfym14fp3z8aqa0";
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
