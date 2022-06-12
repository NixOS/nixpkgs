{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "scheme-manpages-unstable";
  version = "2022-04-21";

  src = fetchFromGitHub {
    owner = "schemedoc";
    repo = "manpages";
    rev = "e3faaa1b80b3493ee644958a105f84f2995a0436";
    sha256 = "sha256-28e6tFRTqX/PWMhdoUZ4nQU1e/JL2uR+NjVXGBwogMM=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/man
    cp -r man3/ man7/ $out/share/man/
  '';

  meta = with lib; {
    description = "Unix manual pages for R6RS and R7RS";
    homepage = "https://github.com/schemedoc/manpages";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
