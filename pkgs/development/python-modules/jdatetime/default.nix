{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "jdatetime";
  version = "5.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LMYD2RPA2OMokoRU09KVJhywN+mVAif2fJYpq0cQ/fk=";
  };

  propagatedBuildInputs = [ six ];

  pythonImportsCheck = [ "jdatetime" ];

  meta = with lib; {
    description = "Jalali datetime binding";
    homepage = "https://github.com/slashmili/python-jalali";
    license = licenses.psfl;
    maintainers = [ ];
  };
}
