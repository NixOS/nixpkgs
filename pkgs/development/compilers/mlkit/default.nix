{ lib, stdenv, fetchFromGitHub, autoreconfHook, mlton }:

stdenv.mkDerivation rec {
  pname = "mlkit";
  version = "4.7.12";

  src = fetchFromGitHub {
    owner = "melsman";
    repo = "mlkit";
    rev = "v${version}";
    sha256 = "sha256-9a2CbIOHdN+kTtm2Z001qOEO/nXuSLrzq0ovgHU1hTQ=";
  };

  nativeBuildInputs = [ autoreconfHook mlton ];

  buildFlags = [ "mlkit" "mlkit_libs" ];

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    echo ==== Running MLKit test suite: test ====
    make -C test_dev test
    echo ==== Running MLKit test suite: test_prof ====
    make -C test_dev test_prof
    runHook postCheck
  '';

  meta = with lib; {
    description = "Standard ML Compiler and Toolkit";
    homepage = "https://elsman.com/mlkit/";
    changelog = "https://github.com/melsman/mlkit/blob/v${version}/NEWS.md";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ athas ];
  };
}
