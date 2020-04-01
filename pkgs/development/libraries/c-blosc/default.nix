{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "c-blosc";
  version = "1.18.1";

  src = fetchFromGitHub {
    owner = "Blosc";
    repo = "c-blosc";
    rev = "v${version}";
    sha256 = "1ywq8j70149859vvs19wgjq89d6xsvvmvm2n1dmkzpchxgrvnw70";
  };

  buildInputs = [ cmake ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A blocking, shuffling and loss-less compression library";
    homepage = "https://www.blosc.org";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
