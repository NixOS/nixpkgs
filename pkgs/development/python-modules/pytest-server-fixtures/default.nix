{ lib, buildPythonPackage, fetchPypi
, pytest, pytest-shutil, pytest-fixture-config, psutil
, requests, future, retry }:

buildPythonPackage rec {
  pname = "pytest-server-fixtures";
  version = "1.7.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-xecz0gqNDnc8pRPjYOS6JkeVLqlCj6K9BVFsYoHqPOc=";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ pytest-shutil pytest-fixture-config psutil requests future retry ];

  # RuntimeError: Unable to find a free server number to start Xvfb
  doCheck = false;

  meta = with lib; {
    description = "Extensible server fixures for py.test";
    homepage  = "https://github.com/manahl/pytest-plugins";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
