{ mkDerivation, fetchFromGitHub }:

mkDerivation {
  pname = "compyte";
  version = "git-20150817";

  src = fetchFromGitHub {
    owner = "inducer";
    repo = "compyte";
    rev = "ac1c71d46428c14aa1bd1c09d7da19cd0298d5cc";
    hash = "sha256-9sXFCgIzCebmz8uN1t5VVugeEKnlVI7dWaJEfAKAAKU=";
  };

  installPhase = ''
    mkdir -p $out
    cp -r * $out
  '';
}
