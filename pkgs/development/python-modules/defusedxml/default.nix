{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "defusedxml";
  version = "0.7.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "183fz8xwclhkirwpvpldyypn47r8lgzfz2mk9jgyg7b37jg5vcc6";
  };

  pythonImportsCheck = [ "defusedxml" ];

  meta = with lib; {
    description = "Python module to defuse XML issues";
    homepage = "https://github.com/tiran/defusedxml";
    license = licenses.psfl;
    maintainers = with maintainers; [ fab ];
  };
}
