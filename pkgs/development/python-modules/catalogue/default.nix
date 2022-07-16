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
  version = "2.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-oczi8XOKMd6yqiSz5Kieb7PoUlVcGDsOzaiivMHq7y4=";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    typing-extensions
    zipp
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.10") [
    # https://github.com/explosion/catalogue/issues/27
    "test_entry_points"
  ];

  pythonImportsCheck = [
    "catalogue"
  ];

  meta = with lib; {
    description = "Tiny library for adding function or object registries";
    homepage = "https://github.com/explosion/catalogue";
    changelog = "https://github.com/explosion/catalogue/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
