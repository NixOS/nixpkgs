{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "trompeloeil";
  version = "40";

  src = fetchFromGitHub {
    owner = "rollbear";
    repo = "trompeloeil";
    rev = "v${version}";
    sha256 = "sha256-q0iMM3Hb5Y21RUhhxFEd/q4OCJFJ12gozZd5jCDscro=";
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
