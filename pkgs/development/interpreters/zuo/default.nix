{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "zuo";
  version = "unstable-2022-04-23";

  src = fetchFromGitHub {
    owner = "racket";
    repo = "zuo";
    rev = "2f3e23bd374f9a6504de6000989ebf2adf67c80c";
    sha256 = "sha256-TxX3iinfL1hXFlQlGQ7x52O6zvYoJYXrMfEfSL4Axig=";
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
