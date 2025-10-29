{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  segno,
  setuptools,
}:

buildPythonPackage rec {
  pname = "fritzconnection";
  version = "1.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kbr";
    repo = "fritzconnection";
    tag = version;
    hash = "sha256-ulY+nh9CSnxrktTlFSXAWJALkS4GwP/3dRIG07jQCWs=";
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
