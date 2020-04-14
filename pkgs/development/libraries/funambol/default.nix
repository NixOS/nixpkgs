{ stdenv, fetchurl, zlib, curl, autoreconfHook, unzip }:

stdenv.mkDerivation {
  name = "funambol-client-cpp-9.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/funambol/funambol-client-sdk-9.0.0.zip";
    sha256 = "1667gahz30i5r8kbv7w415z0hbgm6f6pln1137l5skapi1if6r73";
  };

  postUnpack = ''sourceRoot+="/sdk/cpp/build/autotools"'';

  propagatedBuildInputs = [ zlib curl ];

  nativeBuildInputs = [ autoreconfHook unzip ];

  meta = with stdenv.lib; {
    description = "SyncML client sdk by Funambol project";
    homepage = "http://www.funambol.com";
    license = licenses.agpl3;
    platforms = platforms.unix;
  };
}
