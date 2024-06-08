{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "jdatetime";
  version = "4.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HdDuIQFgx70wACgDxEPmJgrGAuplsGVlKh1WfTv9yno=";
  };

  propagatedBuildInputs = [ six ];

  pythonImportsCheck = [ "jdatetime" ];

  meta = with lib; {
    description = "Jalali datetime binding";
    homepage = "https://github.com/slashmili/python-jalali";
    license = licenses.psfl;
    maintainers = with maintainers; [ ];
  };
}
