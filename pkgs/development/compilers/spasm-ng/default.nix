{
  lib,
  stdenv,
  fetchFromGitHub,
  gcc,
  gmp,
  openssl,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "spasm-ng";

  version = "unstable-2020-08-03";

  src = fetchFromGitHub {
    owner = "alberthdev";
    repo = "spasm-ng";
    rev = "221898beff2442f459b80ab89c8e1035db97868e";
    sha256 = "0xspxmp2fir604b4xsk4hi1gjv61rnq2ypppr7cj981jlhicmvjj";
  };

  nativeBuildInputs = [ gcc ];

  buildInputs = [
    gmp
    openssl
    zlib
  ];

  enableParallelBuilding = true;

  installPhase = ''
    install -Dm755 spasm -t $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/alberthdev/spasm-ng";
    description = "Z80 assembler with extra features to support development for TI calculators";
    mainProgram = "spasm";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.unix;
  };
}
