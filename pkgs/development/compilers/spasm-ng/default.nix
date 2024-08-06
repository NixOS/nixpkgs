{ lib, stdenv, fetchFromGitHub, makeWrapper, gmp, openssl, zlib }:

stdenv.mkDerivation rec {
  pname = "spasm-ng";

  version = "unstable-2022-07-05";

  src = fetchFromGitHub {
    owner = "alberthdev";
    repo = "spasm-ng";
    rev = "5f0786d38f064835be674d4b7df42969967bb73c";
    sha256 = "sha256-j7Z3oI+J0wZF4EG5OMMjuDe2o69KKGuJvfyHNPTLrXM=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ gmp openssl zlib ];

  enableParallelBuilding = true;

  installPhase = ''
    install -Dm755 spasm -t $out/bin
    install -Dm555 inc/*.inc -t $out/include
  '';

  fixupPhase = ''
    wrapProgram $out/bin/spasm --add-flags "-I $out/include"
  '';

  meta = with lib; {
    homepage    = "https://github.com/alberthdev/spasm-ng";
    description = "Z80 assembler with extra features to support development for TI calculators";
    mainProgram = "spasm";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ siraben ];
    platforms   = platforms.unix;
  };
}
