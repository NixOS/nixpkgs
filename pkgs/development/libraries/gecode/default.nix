{ stdenv, fetchFromGitHub, bison, flex, perl, gmp, mpfr, enableGist ? true, qtbase }:

stdenv.mkDerivation rec {
  name = "gecode-${version}";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "Gecode";
    repo = "gecode";
    rev = "release-${version}";
    sha256 = "1ijjy8ppx7djnkrkawsd00rmlf24qh1z13aap0h1azailw1pbrg4";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ bison flex ];
  buildInputs = [ perl gmp mpfr ]
    ++ stdenv.lib.optional enableGist qtbase;

  meta = with stdenv.lib; {
    license = licenses.mit;
    homepage = http://www.gecode.org;
    description = "Toolkit for developing constraint-based systems";
    platforms = platforms.all;
    maintainers = [ ];
  };
}
