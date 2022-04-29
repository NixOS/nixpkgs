{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "hijri-converter";
  version = "2.2.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-5xSc7OzKZHv0Bonsib9ZPHJSsx1pnqWHrQvOkbpC04I=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "hijri_converter"
  ];

  meta = with lib; {
    description = "Accurate Hijri-Gregorian date converter based on the Umm al-Qura calendar";
    homepage = "https://github.com/dralshehri/hijri-converter";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
