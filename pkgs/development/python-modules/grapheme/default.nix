{ lib, buildPythonPackage, fetchPypi, pythonOlder }:

buildPythonPackage rec {
  pname = "grapheme";
  version = "0.6.0";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jiwc3w05c8kh22s3zk7a8km8na3plqc5zimb2qcyxxy3grbkhj4";
  };

  pythonImportsCheck = [ "grapheme" ];

  meta = with lib; {
    homepage = "https://github.com/alvinlindstam/grapheme";
    description = "A python package for grapheme aware string handling";
    maintainers = with maintainers; [ creator54 ];
    license = licenses.mit;
  };
}
