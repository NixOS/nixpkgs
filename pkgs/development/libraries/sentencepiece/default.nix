{ lib
, fetchFromGitHub
, stdenv
, cmake
, gperftools

, withGPerfTools ? true
}:

stdenv.mkDerivation rec {
  pname = "sentencepiece";
  version = "0.1.95";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-xpVihdSpjO/mJWM5nzVg9CND3oAEdfCwXQW0jqLVDBA=";
  };

  nativeBuildInputs = [ cmake ] ++ lib.optional withGPerfTools gperftools;

  outputs = [ "bin" "dev" "out" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/google/sentencepiece";
    description = "Unsupervised text tokenizer for Neural Network-based text generation";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ danieldk pashashocky ];
  };
}
