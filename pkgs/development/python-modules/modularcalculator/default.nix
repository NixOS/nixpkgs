{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  strct,
  python,
  pyyaml,
  scipy,
}:

buildPythonPackage rec {
  pname = "modularcalculator";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JordanL2";
    repo = "ModularCalculator";
    tag = version;
    hash = "sha256-crhpVWCMHIry3gu1hImMEbqjuwUdLUhKPcMc9Gua8f8=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  dependencies = [
    pyyaml
    scipy
    strct
  ];

  checkPhase = ''
    PYTHONPATH=$PYTHONPATH:$PWD ${python.interpreter} tests/tests.py
  '';

  meta = {
    description = "Powerful modular calculator engine";
    homepage = "https://github.com/JordanL2/ModularCalculator";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ Tommimon ];
  };
}
