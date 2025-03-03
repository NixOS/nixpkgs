{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "trompeloeil";
  version = "49";

  src = fetchFromGitHub {
    owner = "rollbear";
    repo = "trompeloeil";
    rev = "v${version}";
    sha256 = "sha256-AyTBHsPYaruq0jadifVqOs80YZ5xwajHdHgMINl3i1Q=";
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
