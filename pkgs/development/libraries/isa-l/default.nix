{ lib, stdenv, fetchFromGitHub, autoreconfHook, nasm }:

stdenv.mkDerivation (finalAttrs: {
  pname = "isa-l";
  version = "2.31.0-unstable-2024-04-25";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "isa-l";
    rev = "dbaf284e112bea1b90983772a3164e794b923aaf";
    sha256 = "sha256-eM1K3uObb4eZq0nSfafltp5DuZIDwknUYj9CdLn14lY=";
  };

  nativeBuildInputs = [ nasm autoreconfHook ];

  preConfigure = ''
    export AS=nasm
  '';

  meta = {
    description = "Collection of optimised low-level functions targeting storage applications";
    mainProgram = "igzip";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/intel/isa-l";
    maintainers = with lib.maintainers; [ jbedo ];
    platforms = lib.platforms.all;
  };
})
