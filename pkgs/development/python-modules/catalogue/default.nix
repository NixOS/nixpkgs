{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, typing-extensions
, zipp
}:

buildPythonPackage rec {
  pname = "catalogue";
  version = "2.0.8";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-syXHdlkgi/tq8bDZOxoapBEuG7KaTFztgWdYpyLw44g=";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    typing-extensions
    zipp
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "catalogue"
  ];

  meta = with lib; {
    description = "Tiny library for adding function or object registries";
    homepage = "https://github.com/explosion/catalogue";
    changelog = "https://github.com/explosion/catalogue/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
