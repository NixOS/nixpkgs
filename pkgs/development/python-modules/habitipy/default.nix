{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  plumbum,
  requests,
  setuptools,
  hypothesis,
  pytestCheckHook,
  responses,
}:

buildPythonPackage rec {
  pname = "habitipy";
  version = "0.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ASMfreaK";
    repo = "habitipy";
    tag = "v${version}";
    hash = "sha256-AEeTCrxLXkokRRnNUfW4y23Qdh8ek1F88GmCPLGb84A=";
  };

  build-system = [ setuptools ];

  dependencies = [
    plumbum
    requests
    setuptools
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
    responses
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTests = [
    # network access
    "test_content_cache"
    # hypothesis.errors.InvalidArgument: tests/test_cli.py::test_data is a function that returns a Hypothesis strategy, but pytest has collected it as a test function.
    "test_data"
  ];

  pythonImportsCheck = [ "habitipy" ];

  meta = with lib; {
    description = "Tools and library for Habitica restful API";
    mainProgram = "habitipy";
    homepage = "https://github.com/ASMfreaK/habitipy";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
