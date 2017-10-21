{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  version = "0.27.1";
  name = "cmark-${version}";

  src = fetchFromGitHub {
    owner = "jgm";
    repo = "cmark";
    rev = version;
    sha256 = "06miwq3rl2bighkn6iq7bdwzmvcqa53qwpa0pqjqa8yn44j8ijj8";
  };

  nativeBuildInputs = [ cmake ];
  doCheck = true;
  checkPhase = ''
    export LD_LIBRARY_PATH=$(readlink -f ./src)
    CTEST_OUTPUT_ON_FAILURE=1 make test
  '';

  meta = with stdenv.lib; {
    description = "CommonMark parsing and rendering library and program in C";
    homepage = https://github.com/jgm/cmark;
    maintainers = [ maintainers.michelk ];
    platforms = platforms.unix;
  };
}
