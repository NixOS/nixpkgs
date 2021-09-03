{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "catalogue";
  version = "2.0.6";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0idjhx2s8cy6ppd18k1zy246d97gdd6i217m5q26fwa47xh3asik";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "catalogue" ];

  meta = with lib; {
    description = "Tiny library for adding function or object registries";
    homepage = "https://github.com/explosion/catalogue";
    changelog = "https://github.com/explosion/catalogue/releases/tag/v${version}";
    license = licenses.mit;
  };
}
