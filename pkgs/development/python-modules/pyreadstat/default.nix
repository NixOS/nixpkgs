{ lib
, stdenv
, buildPythonPackage
, cython
, fetchFromGitHub
, libiconv
, pandas
, python
, pythonOlder
, readstat
, zlib
}:

buildPythonPackage rec {
  pname = "pyreadstat";
  version = "1.1.9";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Roche";
    repo = "pyreadstat";
    rev = "v${version}";
    hash = "sha256-OtvAvZTmcBTGfgp3Ddp9JJuZegr1o6c7rTMOuLwJSpk=";
  };

  nativeBuildInputs = [
    cython
  ];

  buildInputs = [
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    libiconv
  ];

  propagatedBuildInputs = [
    readstat
    pandas
  ];

  pythonImportsCheck = [
    "pyreadstat"
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} tests/test_basic.py

    runHook postCheck
  '';

  meta = with lib; {
    description = "Python package to read SAS, SPSS and Stata files into pandas data frames using the readstat C library";
    homepage = "https://github.com/Roche/pyreadstat";
    license = licenses.asl20;
    maintainers = with maintainers; [ swflint ];
  };
}
