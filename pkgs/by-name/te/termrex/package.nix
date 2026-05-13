{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation (finalAttrs: {
  pname = "termrex";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "SATYADAHAL";
    repo = "termrex";
    rev = "18d381ad9edbeced1386d45b8d7fd3d6c7333876";
    hash = "sha256-5CzfnNgc9tUqQ+Xx+AEGIflaOeVGbD/OgZ5U6S8wTsI=";
  };

  enableParallelBuilding = true;

  makeFlags = [
    "PREFIX=$(out)"
    "BINDIR=$(out)/bin"
  ];

  meta = {
    description = "Terminal-based Chrome Dino Runner clone";
    homepage = "https://github.com/SATYADAHAL/termrex";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vernalan ];
    mainProgram = "termrex";
    platforms = lib.platforms.all;
  };
})
