{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uarmsolver";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = "uARMSolver";
    rev = finalAttrs.version;
    sha256 = "sha256-fJtGZ1Y1mL/JjuaDbLfXb+AjTESEGjoh3ZEmhBZKotA=";
  };

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    install -D -t $out/bin uARMSolver
  '';

  meta = {
    description = "Universal Association Rule Mining Solver";
    mainProgram = "uARMSolver";
    homepage = "https://github.com/firefly-cpp/uARMSolver";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ firefly-cpp ];
  };
})
