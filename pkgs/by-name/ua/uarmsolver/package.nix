{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "uarmsolver";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = "uARMSolver";
    rev = version;
    sha256 = "sha256-IMlh6Y5iVouMZatR1uxw0gUNZBdh2qm56s+GEjcr1+M=";
  };

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    install -D -t $out/bin uARMSolver
  '';

  meta = {
    description = "universal Association Rule Mining Solver";
    mainProgram = "uARMSolver";
    homepage = "https://github.com/firefly-cpp/uARMSolver";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ firefly-cpp ];
  };
}
