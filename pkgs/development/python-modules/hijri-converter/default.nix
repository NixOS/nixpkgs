{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "hijri-converter";
  version = "2.2.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nh2fpMIg9oZ9oquxqWJAZ1rpdKu6lRxoangfTvasIY8=";
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
