{ stdenv, fetchurl, cmake, openal }:

stdenv.mkDerivation rec {
  name = "alure-${version}";
  version = "1.2";

  src = fetchurl {
    url = "http://kcat.strangesoft.net/alure-releases/alure-${version}.tar.bz2";
    sha256 = "0w8gsyqki21s1qb2s5ac1kj08i6nc937c0rr08xbw9w9wvd6lpj6";
  };

  buildInputs = [ cmake openal ];

  meta = with stdenv.lib; {
    description = "A utility library to help manage common tasks with OpenAL applications";
    homepage = http://kcat.strangesoft.net/alure.html;
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
