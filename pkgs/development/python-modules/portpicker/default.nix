{ lib
, buildPythonPackage
, fetchPypi
, psutil
, pythonOlder
}:

buildPythonPackage rec {
  pname = "portpicker";
  version = "1.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4TsUgAit6yeTz4tVvNIP3OxPdj8tO/PEX15eXR330ig=";
  };

  propagatedBuildInputs = [
    psutil
  ];

  pythonImportsCheck = [
    "portpicker"
  ];

  meta = with lib; {
    description = "Library to choose unique available network ports";
    homepage = "https://github.com/google/python_portpicker";
    license = licenses.asl20;
    maintainers = with maintainers; [ danharaj ];
  };
}
