{ stdenv, fetchFromGitHub, cmake, boost } :

stdenv.mkDerivation rec {
  pname = "cm256cc";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "f4exb";
    repo = "cm256cc";
    rev = "v${version}";
    sha256 = "0d16y3lhdwr644am4sxqpshpbc3qik6dgr1w2c39vy75w9ff61a0";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost ];

  meta = with stdenv.lib; {
    description = "Fast GF(256) Cauchy MDS Block Erasure Codec in C++";
    homepage = "https://github.com/f4exb/cm256cc";
    platforms = platforms.linux;
    maintainers = with maintainers; [ alkeryn ];
  };
}
