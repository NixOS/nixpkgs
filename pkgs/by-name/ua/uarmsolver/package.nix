{ lib
, stdenv
, fetchFromGitHub
, cmake
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

  meta = with lib; {
    description = "universal Association Rule Mining Solver";
    mainProgram = "uARMSolver";
    homepage    = "https://github.com/firefly-cpp/uARMSolver";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}
