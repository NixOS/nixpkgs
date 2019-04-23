{ stdenv, fetchFromGitHub, bison, flex, perl, gmp, mpfr, enableGist ? true, qtbase }:

stdenv.mkDerivation rec {
  name = "gecode-${version}";
  version = "6.1.1";

  src = fetchFromGitHub {
    owner = "Gecode";
    repo = "gecode";
    rev = "release-${version}";
    sha256 = "07jyx17qsfx3wmd2zlcs0rxax8h3cs2g9aapxkdjdcsmfxsldqb7";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ bison flex ];
  buildInputs = [ perl gmp mpfr ]
    ++ stdenv.lib.optional enableGist qtbase;

  meta = with stdenv.lib; {
    license = licenses.mit;
    homepage = https://www.gecode.org;
    description = "Toolkit for developing constraint-based systems";
    platforms = platforms.all;
    maintainers = [ ];
  };
}
