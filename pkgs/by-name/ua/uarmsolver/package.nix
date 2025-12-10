{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "uarmsolver";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = "uARMSolver";
    rev = version;
    sha256 = "sha256-fJtGZ1Y1mL/JjuaDbLfXb+AjTESEGjoh3ZEmhBZKotA=";
  };

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    install -D -t $out/bin uARMSolver
  '';

  meta = with lib; {
    description = "Universal Association Rule Mining Solver";
    mainProgram = "uARMSolver";
    homepage = "https://github.com/firefly-cpp/uARMSolver";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}
