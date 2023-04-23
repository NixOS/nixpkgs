{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "scheme-manpages";
  version = "unstable-2023-03-26";

  src = fetchFromGitHub {
    owner = "schemedoc";
    repo = "manpages";
    rev = "eac67db33b2111f19ac267585032df8b4838e6f4";
    hash = "sha256-FBoagGHWsxZo40gOqeBUw0L+LtNAVF/q6IZ3N9QBFQs=";
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
