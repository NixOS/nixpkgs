{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "c-blosc-${version}";
  version = "1.14.3";

  src = fetchFromGitHub {
    owner = "Blosc";
    repo = "c-blosc";
    rev = "v${version}";
    sha256 = "051x2hh0yq1zhiyjmiarvc2radi59v03vzs2sa4hmgfhfaxcklld";
  };

  buildInputs = [ cmake ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A blocking, shuffling and loss-less compression library";
    homepage = http://www.blosc.org;
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
