{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "zuo";
  version = "1.9";

  src = fetchFromGitHub {
    owner = "racket";
    repo = "zuo";
    rev = "v${version}";
    hash = "sha256-F7ba/4VVVhNDK/wqk+kgJKYxETS2pR9ZiDh0O0aOWn0=";
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
