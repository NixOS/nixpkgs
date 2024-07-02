{ lib, stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, nasm }:

stdenv.mkDerivation rec {
  pname = "isa-l";
  version = "2.31.0";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "isa-l";
    rev = "v${version}";
    sha256 = "sha256-xBBtpjtWyba0DogdLobtuWmiiAHTXMK4oRnjYuTUCNk=";
  };

  patches = [
    # From https://github.com/intel/isa-l/pull/226
    (fetchpatch {
      name = "darwin-aarch64-fold-constant.patch";
      url = "https://github.com/intel/isa-l/commit/3c784749380f7f167ff7777fd0414f138f9debd5.patch";
      hash = "sha256-Fctw7xpdfbQySQpjBB8gLe4m1jF6OYmp179dIue2v7c=";
    })
  ];

  nativeBuildInputs = [ nasm autoreconfHook ];

  preConfigure = ''
    export AS=nasm
  '';

  doCheck = true;
  checkPhase = ''
    make test
  '';

  meta = with lib; {
    description = "Collection of optimised low-level functions targeting storage applications";
    mainProgram = "igzip";
    license = licenses.bsd3;
    homepage = "https://github.com/intel/isa-l";
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.all;
  };
}
