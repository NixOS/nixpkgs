{ lib, buildPythonPackage, fetchPypi
, pytest, pytest-shutil, pytest-fixture-config, psutil
, requests, future, retry }:

buildPythonPackage rec {
  pname = "pytest-server-fixtures";
  version = "1.7.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07vdv3y89qzv89ws0y48h92yplqsx208b9cizx80w644dazb398g";
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
