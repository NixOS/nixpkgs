{ lib
, buildPythonPackage
, fetchPypi
, six
, pythonOlder
}:

buildPythonPackage rec {
  pname = "jdatetime";
  version = "3.8.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "db57ee517356b1bfc1603ef412f5da61eae92241ba0bcaf0851028cae424780c";
  };

  propagatedBuildInputs = [
    six
  ];

  pythonImportsCheck = [
    "jdatetime"
  ];

  meta = with lib; {
    description = "Jalali datetime binding";
    homepage = "https://github.com/slashmili/python-jalali";
    license = licenses.psfl;
    maintainers = with maintainers; [ ];
  };
}
