{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "trompeloeil";
  version = "37";

  src = fetchFromGitHub {
    owner = "rollbear";
    repo = "trompeloeil";
    rev = "v${version}";
    sha256 = "04f9vpzh4fc15w4ynirzs9ipm9r31dbggb2zilmk0fj4qr79am42";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "Header only C++14 mocking framework";
    homepage = "https://github.com/rollbear/trompeloeil";
    license = licenses.boost;
    maintainers = [ maintainers.bjornfor ];
    platforms = platforms.unix;
  };
}
