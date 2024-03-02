{ lib, stdenv, fetchFromGitHub, cmake, fmt }:

stdenv.mkDerivation {
  pname = "termbench-pro";
  version = "unstable-2023-01-26";

  src = fetchFromGitHub {
    owner = "contour-terminal";
    repo = "termbench-pro";
    rev = "a4feadd3a698e4fe2d9dd5b03d5f941534a25a91";
    hash = "sha256-/zpJY9Mecalk7dneYZYzmFOroopFGklWw62a+LbiUVs=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ fmt ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/lib
    mv termbenchpro/tbp $out/bin
    mv libtermbench/libtermbench.a $out/lib

    runHook postInstall
  '';

  meta = with lib; {
    description = "Terminal Benchmarking as CLI and library";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ moni ];
  };
}
