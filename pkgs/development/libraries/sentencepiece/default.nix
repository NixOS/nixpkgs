{ lib
, fetchFromGitHub
, stdenv
, cmake
, gperftools

, withGPerfTools ? true
}:

stdenv.mkDerivation rec {
  pname = "sentencepiece";
  version = "0.1.97";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-T6qQtLmuPKVha0CwX4fBH7IQoAlwVj64X2qDecWd7s8=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals withGPerfTools [ gperftools ];

  outputs = [ "bin" "dev" "out" ];

  meta = with lib; {
    homepage = "https://github.com/google/sentencepiece";
    description = "Unsupervised text tokenizer for Neural Network-based text generation";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pashashocky ];
  };
}
