{ lib
, stdenv
, buildPythonPackage
, cython_3
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
  version = "1.2.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Roche";
    repo = "pyreadstat";
    rev = "refs/tags/v${version}";
    hash = "sha256-+wa8HxQyEwdGF2LWJXTZ/gOFpC8P9+k5p4Lj3ePP2n8=";
  };

  nativeBuildInputs = [
    cython_3
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
    description = "Module to read SAS, SPSS and Stata files into pandas data frames";
    homepage = "https://github.com/Roche/pyreadstat";
    changelog = "https://github.com/Roche/pyreadstat/blob/v${version}/change_log.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ swflint ];
  };
}
