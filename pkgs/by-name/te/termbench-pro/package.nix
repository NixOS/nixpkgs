{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fmt,
  glaze,
}:

stdenv.mkDerivation {
  pname = "termbench-pro";
  version = "unstable-2025-01-01";

  src = fetchFromGitHub {
    owner = "contour-terminal";
    repo = "termbench-pro";
    rev = "3a39a4ad592047dee3038d8bfcce84215ac55032";
    hash = "sha256-EvTHBPWLGm2FxEVOwMIXH4UW/15rbXPnxEnjMtSg4YM=";
  };

  # don't fetch glaze from CMakeLists.txt
  patches = [ ./dont-fetchcontent.diff ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    fmt
    (glaze.override { enableSSL = false; })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/lib
    mv tb/tb $out/bin
    mv libtermbench/libtermbench.* $out/lib

    runHook postInstall
  '';

  meta = with lib; {
    description = "Terminal Benchmarking as CLI and library";
    mainProgram = "tb";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ moni ];
  };
}
