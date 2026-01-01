{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "uarmsolver";
<<<<<<< HEAD
  version = "0.4.0";
=======
  version = "0.3.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = "uARMSolver";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-fJtGZ1Y1mL/JjuaDbLfXb+AjTESEGjoh3ZEmhBZKotA=";
=======
    sha256 = "sha256-IMlh6Y5iVouMZatR1uxw0gUNZBdh2qm56s+GEjcr1+M=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    install -D -t $out/bin uARMSolver
  '';

<<<<<<< HEAD
  meta = {
    description = "Universal Association Rule Mining Solver";
    mainProgram = "uARMSolver";
    homepage = "https://github.com/firefly-cpp/uARMSolver";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ firefly-cpp ];
=======
  meta = with lib; {
    description = "Universal Association Rule Mining Solver";
    mainProgram = "uARMSolver";
    homepage = "https://github.com/firefly-cpp/uARMSolver";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ firefly-cpp ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
