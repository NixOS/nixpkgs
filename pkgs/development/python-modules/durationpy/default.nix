{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "durationpy";
  version = "0.7";

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-hEfEPfTxoLQ05wwVo4139cm9FyhL/B/x1DDyM9UINzI=";
  };

  pythonImportsCheck = [ "durationpy" ];

  meta = with lib; {
    description = "Module for converting between datetime.timedelta and Go's Duration strings";
    homepage = "https://github.com/icholy/durationpy";
    license = licenses.mit;
  };
}
