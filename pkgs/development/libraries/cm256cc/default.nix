{ lib, stdenv, fetchFromGitHub, cmake, boost } :

stdenv.mkDerivation rec {
  pname = "cm256cc";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "f4exb";
    repo = "cm256cc";
    rev = "v${version}";
    sha256 = "sha256-T7ZUVVYGdzAialse//MoqWCVNBpbZvzWMAKc0cw7O9k=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost ];

  meta = with lib; {
    description = "Fast GF(256) Cauchy MDS Block Erasure Codec in C++";
    homepage = "https://github.com/f4exb/cm256cc";
    platforms = platforms.linux;
    maintainers = with maintainers; [ alkeryn ];
    license = licenses.gpl3;
  };
}
