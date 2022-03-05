{ lib
, buildPythonPackage
, fetchPypi
, six
, pythonOlder
}:

buildPythonPackage rec {
  pname = "jdatetime";
  version = "4.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-01uuou0hPk6Hu4QMYWNwAVQL0h6ORFS9EjUrBlkewI4=";
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
