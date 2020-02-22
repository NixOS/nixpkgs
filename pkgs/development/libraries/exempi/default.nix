{ stdenv, fetchurl, fetchpatch, expat, zlib, boost, libiconv, darwin }:

stdenv.mkDerivation rec {
  pname = "exempi";
  version = "2.5.1";

  src = fetchurl {
    url = "https://libopenraw.freedesktop.org/download/${pname}-${version}.tar.bz2";
    sha256 = "07i29xmg8bqriviaf4vi1mwha4lrw85kfla29cfym14fp3z8aqa0";
  };

  configureFlags = [
    "--with-boost=${boost.dev}"
  ];

  buildInputs = [ expat zlib boost ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv darwin.apple_sdk.frameworks.CoreServices ];

  doCheck = stdenv.isLinux;

  meta = with stdenv.lib; {
    description = "An implementation of XMP (Adobe's Extensible Metadata Platform)";
    homepage = "https://libopenraw.freedesktop.org/wiki/Exempi/";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.bsd3;
  };
}
