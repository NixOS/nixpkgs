{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "trompeloeil";
  version = "41";

  src = fetchFromGitHub {
    owner = "rollbear";
    repo = "trompeloeil";
    rev = "v${version}";
    sha256 = "sha256-NsWRN520K4FLp+8W83bXT6pgQEADYFnWiB6gy3MjsWY=";
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
