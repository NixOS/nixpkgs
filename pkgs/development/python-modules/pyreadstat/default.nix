{
  lib,
  stdenv,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  libiconv,
  pandas,
  python,
  pythonOlder,
  readstat,
  setuptools,
  zlib,
}:

buildPythonPackage rec {
  pname = "pyreadstat";
  version = "1.2.7";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Roche";
    repo = "pyreadstat";
    rev = "refs/tags/v${version}";
    hash = "sha256-XuLFLpZbaCj/MHq0+l6GoNqR5nAldAlEJhoO5ioWYTA=";
  };

  build-system = [
    cython
    setuptools
  ];

  buildInputs = [ zlib ] ++ lib.optionals stdenv.isDarwin [ libiconv ];

  dependencies = [
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

  meta = with lib; {
    description = "Module to read SAS, SPSS and Stata files into pandas data frames";
    homepage = "https://github.com/Roche/pyreadstat";
    changelog = "https://github.com/Roche/pyreadstat/blob/v${version}/change_log.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ swflint ];
  };
}
