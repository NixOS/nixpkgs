{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "c-blosc-${version}";
  version = "1.16.3";

  src = fetchFromGitHub {
    owner = "Blosc";
    repo = "c-blosc";
    rev = "v${version}";
    sha256 = "1c58wkf34rp5wh9qp09zdk7zcfn037sk56p4xq1g0vapbnglv603";
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
