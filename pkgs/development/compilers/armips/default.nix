{ stdenv, lib, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "armips";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "Kingcom";
    repo = "armips";
    rev = "v${version}";
    sha256 = "sha256-L+Uxww/WtvDJn1xZqoqA6Pkzq/98sy1qTxZbv6eEjbA=";
  };

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp armips $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/Kingcom/armips";
    description = "Assembler for various ARM and MIPS platforms";
    mainProgram = "armips";
    license = licenses.mit;
    maintainers = with maintainers; [ marius851000 ];
  };
}
