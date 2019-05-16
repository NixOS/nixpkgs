{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "c-blosc-${version}";
  version = "1.16.2";

  src = fetchFromGitHub {
    owner = "Blosc";
    repo = "c-blosc";
    rev = "v${version}";
    sha256 = "19wb699rb5bn6h9qhw1m18m2w77lws7r50vxpgrvggnl27mvm3xc";
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
