{ lib, stdenv, fetchFromGitHub, mlton }:

stdenv.mkDerivation {
  pname = "ceptre";
  version = "unstable-2016-11-27";

  src = fetchFromGitHub {
    owner = "chrisamaphone";
    repo = "interactive-lp";
    rev = "e436fda2ccd44e9c9d226feced9d204311deacf5";
    sha256 = "sha256-COYrE9O/Y1/ZBNHNakBwrUVklCuk144RF9bjwa3rl5w=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ mlton ];

  installPhase = ''
    mkdir -p $out/bin
    cp ceptre $out/bin
  '';

  meta = with lib; {
    description = "A linear logic programming language for modeling generative interactive systems";
    homepage = "https://github.com/chrisamaphone/interactive-lp";
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.unix;
  };
}
