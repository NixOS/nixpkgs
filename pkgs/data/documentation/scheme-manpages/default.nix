{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "scheme-manpages-unstable";
  version = "2021-03-11";

  src = fetchFromGitHub {
    owner = "schemedoc";
    repo = "manpages";
    rev = "d0163a4e29d29b2f0beb762be4095775134f5ef9";
    sha256 = "0a8f7rq458c7985chwn1qb9yxcwyr0hl39r9vlvm5j687hy3igs2";
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
