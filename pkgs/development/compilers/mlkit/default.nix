{ stdenv, fetchFromGitHub, autoreconfHook, mlton }:

stdenv.mkDerivation rec {
  pname = "mlkit";
  version = "4.5.2";

  src = fetchFromGitHub {
    owner = "melsman";
    repo = "mlkit";
    rev = "v${version}";
    sha256 = "1yk7phxnwkm94qs1gbxsr6sr11a0sgpcyjymmqwf0fsl5njgyb98";
  };

  nativeBuildInputs = [ autoreconfHook mlton ];

  buildFlags = ["mlkit" "mlkit_libs"];

  meta = with stdenv.lib; {
    description = "Standard ML Compiler and Toolkit";
    homepage = "https://elsman.com/mlkit/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ athas ];
  };
}
