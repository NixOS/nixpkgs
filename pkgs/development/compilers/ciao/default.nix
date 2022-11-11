{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "ciao";
  version = "1.22.0-m1";
  src = fetchFromGitHub {
    owner = "ciao-lang";
    repo = "ciao";
    rev = "v${version}";
    sha256 = "sha256-p7QNSsDI8hVMPPfkX3PNjJo01hsPGKZ7jMR9Kmj2qxY=";
  };

  configurePhase = ''
    ./ciao-boot.sh configure --instype=global --prefix=$prefix
  '';

  buildPhase = ''
    ./ciao-boot.sh build
  '';

  installPhase = ''
    ./ciao-boot.sh install
  '';

  meta = with lib; {
    homepage = "https://ciao-lang.org/";
    description = "A general purpose, multi-paradigm programming language in the Prolog family";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ suhr ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/ciao.x86_64-darwin
  };
}
