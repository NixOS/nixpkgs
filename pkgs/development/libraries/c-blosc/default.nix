{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "c-blosc-${version}";
  version = "1.14.4";

  src = fetchFromGitHub {
    owner = "Blosc";
    repo = "c-blosc";
    rev = "v${version}";
    sha256 = "195w96gl75mkxxqq6qjsmb2s1lq8z95qlc71fr5a7sckslcwglh0";
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
