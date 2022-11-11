{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "zuo";
  version = "unstable-2022-11-12";

  src = fetchFromGitHub {
    owner = "racket";
    repo = "zuo";
    rev = "244cb2a15ce8e48cde9bd7080526840d296c5b5c";
    hash = "sha256-4+YL6rHv+gyBx+Gj66fmAN4qbdkCuWVx1HUs3l0tUUw=";
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
