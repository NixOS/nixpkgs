{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "datadiff";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VASUQKiW3lJH7i57eqVCX5OayDLDftshAfjTA26Jyqg=";
  };

  # Tests are not part of the PyPI releases
  doCheck = false;

  pythonImportsCheck = [
    "datadiff"
  ];

  meta = with lib; {
    description = "Library to provide human-readable diffs of Python data structures";
    homepage = "https://sourceforge.net/projects/datadiff/";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
