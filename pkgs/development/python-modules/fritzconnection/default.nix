{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  segno,
  setuptools,
}:

buildPythonPackage rec {
  pname = "fritzconnection";
  version = "1.14.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "kbr";
    repo = "fritzconnection";
    rev = "refs/tags/${version}";
    hash = "sha256-1LLfSEOKqUIhWIR/RQEG0Bp41d908hAKDlslJlWCHys=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  optional-dependencies = {
    qr = [ segno ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$TEMP
  '';

  pythonImportsCheck = [ "fritzconnection" ];

  disabledTestPaths = [
    # Functional tests require network access
    "fritzconnection/tests/test_functional.py"
  ];

  meta = with lib; {
    description = "Python module to communicate with the AVM Fritz!Box";
    homepage = "https://github.com/kbr/fritzconnection";
    changelog = "https://fritzconnection.readthedocs.io/en/${version}/sources/version_history.html";
    license = licenses.mit;
    maintainers = with maintainers; [
      dotlambda
      valodim
    ];
  };
}
