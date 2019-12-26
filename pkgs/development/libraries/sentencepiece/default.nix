{ config
, fetchFromGitHub
, stdenv
, lib
, cmake
, gperftools
}:

stdenv.mkDerivation rec {
  pname = "sentencepiece";
  version = "0.1.84";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "144y25nj4rwxmgvzqbr7al9fjwh3539ssjswvzrx4gsgfk62lsm0";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake gperftools ];

  meta = with stdenv.lib; {
    homepage = https://github.com/google/sentencepiece;
    description = "Unsupervised text tokenizer for Neural Network-based text generation";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ pashashocky ];
  };
}
