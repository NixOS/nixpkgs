{ lib, stdenv, fetchFromGitHub, unstableGitUpdater }:

stdenv.mkDerivation rec {
  pname = "zuo";
  version = "unstable-2023-11-23";

  src = fetchFromGitHub {
    owner = "racket";
    repo = "zuo";
    rev = "4d85edb4f221de8a1748ee38dcc6963d8d2da33a";
    hash = "sha256-pFEXkByZpVnQgXK1DeFSEnalvhCTwOy75WrRojBM78U=";
  };

  doCheck = true;

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "A Tiny Racket for Scripting";
    homepage = "https://github.com/racket/zuo";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.marsam ];
  };
}
