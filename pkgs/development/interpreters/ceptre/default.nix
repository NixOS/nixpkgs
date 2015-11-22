{ stdenv, fetchgit, mlton }:

stdenv.mkDerivation rec {
  name = "ceptre-2015-11-20";

  src = fetchgit {
    url = https://github.com/chrisamaphone/interactive-lp;
    rev = "adb59d980f903e49a63b668618241d1b8beb28be";
    sha256 = "1pyl2imrvq2icr2rr4ys7djnizppbgqldgsv5525xsvzm78w3ac7";
  };

  nativeBuildInputs = [ mlton ];

  installPhase = ''
    mkdir -p $out/bin
    cp ceptre $out/bin
  '';

  meta = with stdenv.lib; {
    description = "A linear logic programming language for modeling generative interactive systems";
    homepage = https://github.com/chrisamaphone/interactive-lp;
    maintainers = with maintainers; [ pSub ];
  };
}
