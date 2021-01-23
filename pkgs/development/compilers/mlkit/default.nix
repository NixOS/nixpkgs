{ lib, stdenv, fetchFromGitHub, autoreconfHook, mlton }:

stdenv.mkDerivation rec {
  pname = "mlkit";
  version = "4.5.6";

  src = fetchFromGitHub {
    owner = "melsman";
    repo = "mlkit";
    rev = "v${version}";
    sha256 = "sha256-aa6dRcGTXGakJsHCvHXRKs5BHtIZi6V2r8348epzpVc=";
  };

  nativeBuildInputs = [ autoreconfHook mlton ];

  buildFlags = ["mlkit" "mlkit_libs"];

  meta = with lib; {
    description = "Standard ML Compiler and Toolkit";
    homepage = "https://elsman.com/mlkit/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ athas ];
  };
}
