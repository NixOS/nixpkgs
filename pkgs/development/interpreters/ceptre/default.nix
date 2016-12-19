{ stdenv, fetchgit, mlton }:

stdenv.mkDerivation rec {
  name = "ceptre-2016-01-01";

  src = fetchgit {
    url = https://github.com/chrisamaphone/interactive-lp;
    rev = "b3d21489d4994f03d2982de273eea90bc7fba5d0";
    sha256 = "1qpyasr3jg4i2x547yq1dzksvjagvnrmkdd00s108wvw9npc2jj1";
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
