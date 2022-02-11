{ lib
, buildPythonPackage
, fetchPypi
, six
, pythonOlder
}:

buildPythonPackage rec {
  pname = "jdatetime";
  version = "3.8.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c685687e3f39e1b9a3ba9c00ed9d8e88603bc8994413e84623e6c5d43214e6f8";
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
