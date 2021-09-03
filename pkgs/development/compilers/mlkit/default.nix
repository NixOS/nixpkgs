{ lib, stdenv, fetchFromGitHub, autoreconfHook, mlton }:

stdenv.mkDerivation rec {
  pname = "mlkit";
  version = "4.5.7";

  src = fetchFromGitHub {
    owner = "melsman";
    repo = "mlkit";
    rev = "v${version}";
    sha256 = "sha256-Wq+Os7nzRA5Pxz6Ba7DudcDQs3KA0eYVLy1nO/A16EE=";
  };

  nativeBuildInputs = [ autoreconfHook mlton ];

  buildFlags = ["mlkit" "mlkit_libs"];

  meta = with lib; {
    description = "Standard ML Compiler and Toolkit";
    homepage = "https://elsman.com/mlkit/";
    changelog = "https://github.com/melsman/mlkit/blob/v${version}/NEWS.md";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ athas ];
  };
}
