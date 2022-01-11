{ lib
, buildPythonPackage
, isPy27
, fetchPypi
, pythonOlder
, importlib-metadata
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "exdown";
  version = "0.9.0";
  format = "pyproject";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-r0SCigkUpOiba4MDf80+dLjOjjruVNILh/raWfvjXA0=";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "exdown" ];

  meta = with lib; {
    description = "Extract code blocks from markdown";
    homepage = "https://github.com/nschloe/exdown";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
