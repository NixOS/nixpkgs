{ lib
, fetchPypi
, buildPythonPackage
, click
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "click-help-colors";
  version = "0.9.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dWJF5ULSkia7O8BWv6WIhvISuiuC9OjPX8iEF2rJbXI=";
  };

  propagatedBuildInputs = [
    click
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "click_help_colors"
  ];

  meta = with lib; {
    description = "Colorization of help messages in Click";
    homepage = "https://github.com/click-contrib/click-help-colors";
    changelog = "https://github.com/click-contrib/click-help-colors/blob/${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ freezeboy ];
  };
}
