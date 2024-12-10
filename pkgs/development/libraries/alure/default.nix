{
  lib,
  stdenv,
  fetchurl,
  cmake,
  openal,
}:

stdenv.mkDerivation rec {
  pname = "alure";
  version = "1.2";

  src = fetchurl {
    url = "http://kcat.strangesoft.net/alure-releases/alure-${version}.tar.bz2";
    sha256 = "0w8gsyqki21s1qb2s5ac1kj08i6nc937c0rr08xbw9w9wvd6lpj6";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ openal ];

  meta = with lib; {
    description = "A utility library to help manage common tasks with OpenAL applications";
    homepage = "https://github.com/kcat/alure";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
