{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "c-blosc";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "Blosc";
    repo = "c-blosc";
    rev = "v${version}";
    sha256 = "0c4vh7kyxm57jclk8jlcnc11w7nd2m81qk454gav58aji85w16hg";
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
