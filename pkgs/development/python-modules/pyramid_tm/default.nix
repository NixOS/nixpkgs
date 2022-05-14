{ lib
, buildPythonPackage
, fetchPypi
, transaction
, pyramid
, setuptools
}:

buildPythonPackage rec {
  pname = "pyramid_tm";
  version = "2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5fd6d4ac9181a65ec54e5b280229ed6d8b3ed6a8f5a0bcff05c572751f086533";
  };

  propagatedBuildInputs = [ pyramid transaction setuptools ];

  pythonImportsCheck = [ "pyramid_tm" ];

  meta = with lib; {
    description = "Transaction manager for pyramid";
    homepage = "https://github.com/Pylons/pyramid_tm";
    license = licenses.bsd0;
    maintainers = with maintainers; [ holgerpeters ];
  };
}
