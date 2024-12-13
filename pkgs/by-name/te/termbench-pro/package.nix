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
  version = "unstable-2024-10-05";

  src = fetchFromGitHub {
    owner = "contour-terminal";
    repo = "termbench-pro";
    rev = "22a0c42f78dc2e522eb1089bf9976a9ff0ecdcad";
    hash = "sha256-Yyvlu/yx/yGc9Ci9Pn098YfTdywLZEaowQZeLM4WGjQ";
  };

  # don't fetch glaze from CMakeLists.txt
  patches = [ ./dont-fetchcontent.diff ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    fmt
    glaze
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
