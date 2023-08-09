{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "zuo";
  version = "unstable-2023-01-02";

  src = fetchFromGitHub {
    owner = "racket";
    repo = "zuo";
    rev = "464aae9ae90dcb43ab003b922e4ae4d08611c55b";
    hash = "sha256-O8p3dEXqAP2UNPNBla9AtkndxgL8UoVp/QygXOmcgWg=";
  };

  doCheck = true;

  meta = with lib; {
    description = "A Tiny Racket for Scripting";
    homepage = "https://github.com/racket/zuo";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.marsam ];
  };
}
