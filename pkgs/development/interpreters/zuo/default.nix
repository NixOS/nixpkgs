{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "zuo";
  version = "unstable-2022-07-25";

  src = fetchFromGitHub {
    owner = "racket";
    repo = "zuo";
    rev = "18778d759e7af1d9c4b6ce7649a3aa4a49a2aa7f";
    sha256 = "sha256-Y5+C1UdaeweYaGqomC1dFmTF8qGDquuP42Bn6QbZ9nk=";
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
