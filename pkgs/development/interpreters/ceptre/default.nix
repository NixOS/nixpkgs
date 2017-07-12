{ stdenv, fetchFromGitHub, mlton }:

stdenv.mkDerivation rec {
  name = "ceptre-2016-11-27";

  src = fetchFromGitHub {
    owner = "chrisamaphone";
    repo = "interactive-lp";
    rev = "e436fda2ccd44e9c9d226feced9d204311deacf5";
    sha256 = "0gh9npcf50wapks93xfy7626jf9dk6m8zh1pi7d1df49nyjbj813";
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
    platforms = with platforms; linux;
  };
}
