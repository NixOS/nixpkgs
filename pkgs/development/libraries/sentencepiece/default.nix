{ lib
, fetchFromGitHub
, stdenv
, cmake
, gperftools

, withGPerfTools ? true
}:

stdenv.mkDerivation rec {
  pname = "sentencepiece";
  version = "0.1.94";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256:11cqw4hx33gw2jmrg11jyp7fj9pwzwjwzqcn24jfsbgh6n8gks5x";
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
