{ stdenv, fetchgit, mlton }:

stdenv.mkDerivation rec {
  name = "ceptre-2015-08-30";

  src = fetchgit {
    url = https://github.com/chrisamaphone/interactive-lp;
    rev = "f16ebee257d63396b8456c48698d255c118d7157";
    sha256 = "0d5s8nzsjl3l7g723588l19j3pyxkdrqnfs9nngv1d9syqyb5395";
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
