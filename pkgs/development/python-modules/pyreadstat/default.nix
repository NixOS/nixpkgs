{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  narwhals,
  pandas,
  python,
  readstat,
  setuptools,
  zlib,
}:

buildPythonPackage rec {
  pname = "pyreadstat";
  version = "1.3.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Roche";
    repo = "pyreadstat";
    tag = "v${version}";
    hash = "sha256-CvnY6cfaH3qaphkIPorA4tfbareWml7ksyU/jDEZ6/U=";
  };

  build-system = [
    cython
    setuptools
  ];

  buildInputs = [ zlib ];

  dependencies = [
    narwhals
    readstat
    pandas
  ];

  pythonImportsCheck = [ "pyreadstat" ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} tests/test_basic.py

    runHook postCheck
  '';

  meta = {
    description = "Module to read SAS, SPSS and Stata files into pandas data frames";
    homepage = "https://github.com/Roche/pyreadstat";
    changelog = "https://github.com/Roche/pyreadstat/blob/${src.tag}/change_log.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ swflint ];
  };
}
