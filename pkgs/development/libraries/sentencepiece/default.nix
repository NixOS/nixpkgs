{ config
, fetchFromGitHub
, stdenv
, lib
, cmake
, gperftools
}:

stdenv.mkDerivation rec {
  pname = "sentencepiece";
  version = "0.1.85";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ncvyw9ar0z7nd47cysxg5xrjm01y1shdlhp8l2pdpx059p3yx3w";
  };

  nativeBuildInputs = [ cmake gperftools ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/google/sentencepiece";
    description = "Unsupervised text tokenizer for Neural Network-based text generation";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pashashocky ];
  };
}
