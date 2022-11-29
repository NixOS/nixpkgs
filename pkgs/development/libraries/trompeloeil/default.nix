{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "trompeloeil";
  version = "43";

  src = fetchFromGitHub {
    owner = "rollbear";
    repo = "trompeloeil";
    rev = "v${version}";
    sha256 = "sha256-+Eihm5dFy72iYtkwx+p8yv9og3e/dpkzo47TV+wzbbM=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Header only C++14 mocking framework";
    homepage = "https://github.com/rollbear/trompeloeil";
    license = licenses.boost;
    maintainers = [ maintainers.bjornfor ];
    platforms = platforms.unix;
  };
}
