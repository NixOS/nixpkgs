{
  lib,
  buildPythonPackage,
  fetchPypi,
  termcolor,
  pytest,
  packaging,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pytest-sugar";
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZCLoMlj1sMBM58YyF2x3Msq1/bkJyznMpckTn4EnbAo=";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    termcolor
    packaging
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "A plugin that changes the default look and feel of pytest";
    homepage = "https://github.com/Frozenball/pytest-sugar";
    changelog = "https://github.com/Teemu/pytest-sugar/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
