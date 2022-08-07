{ lib, stdenv, fetchFromGitHub, autoreconfHook, mlton }:

stdenv.mkDerivation rec {
  pname = "mlkit";
  version = "4.6.1";

  src = fetchFromGitHub {
    owner = "melsman";
    repo = "mlkit";
    rev = "v${version}";
    sha256 = "sha256-04G9G14fhEh8wwgqHwUR+sbYU3zaZcFV0q5SoAKcyjY=";
  };

  nativeBuildInputs = [ autoreconfHook mlton ];

  buildFlags = [ "mlkit" "mlkit_libs" ];

  meta = with lib; {
    description = "Standard ML Compiler and Toolkit";
    homepage = "https://elsman.com/mlkit/";
    changelog = "https://github.com/melsman/mlkit/blob/v${version}/NEWS.md";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ athas ];
  };
}
