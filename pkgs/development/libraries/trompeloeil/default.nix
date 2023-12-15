{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "trompeloeil";
  version = "46";

  src = fetchFromGitHub {
    owner = "rollbear";
    repo = "trompeloeil";
    rev = "v${version}";
    sha256 = "sha256-x/Chzho6RTfyOb/Is7bAM8KrvipEqQ/+a6pVCuTG108=";
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
