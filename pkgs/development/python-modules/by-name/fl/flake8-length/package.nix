{
  lib,
  buildPythonPackage,
  fetchPypi,
  flake8,
  flit-core,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "flake8-length";
  version = "0.3.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Dr1hTCU2G1STczXJsUPMGFYs1NpIAk1I95vxXsRTtRA=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ flake8 ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "flake8_length" ];

  enabledTestPaths = [ "tests/" ];

  meta = with lib; {
    description = "Flake8 plugin for a smart line length validation";
    homepage = "https://github.com/orsinium-labs/flake8-length";
    changelog = "https://github.com/orsinium-labs/flake8-length/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ sauyon ];
  };
}
