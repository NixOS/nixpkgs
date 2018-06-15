{ stdenv, lib, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "linenoise-ng-${version}";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "arangodb";
    repo = "linenoise-ng";
    rev = "v${version}";
    sha256 = "176iz0kj0p8d8i3jqps4z8xkxwl3f1986q88i9xg5fvqgpzsxp20";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = https://github.com/arangodb/linenoise-ng;
    description = "A small, portable GNU readline replacement for Linux, Windows and MacOS which is capable of handling UTF-8 characters";
    maintainers = with stdenv.lib.maintainers; [ cstrahan ];
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.bsd3;
  };
}
