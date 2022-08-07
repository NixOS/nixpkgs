{ lib
, buildPythonPackage
, fetchPypi
, psutil
, pythonOlder
}:

buildPythonPackage rec {
  pname = "portpicker";
  version = "1.5.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xVaDrXJfXACkG8fbAiUiPovgJLH6Vk0DntM5Dk/Uj7M=";
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
    maintainers = with maintainers; [ ];
  };
}
