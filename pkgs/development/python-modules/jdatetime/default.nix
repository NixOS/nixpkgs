{ lib
, buildPythonPackage
, fetchPypi
, six
, pythonOlder
}:

buildPythonPackage rec {
  pname = "jdatetime";
  version = "4.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-SmeoLuV+NbX2+ff75qDtpj9Wzh3Yr0CbTComozQEV9s=";
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
