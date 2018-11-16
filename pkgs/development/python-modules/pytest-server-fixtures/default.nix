{ stdenv, buildPythonPackage, fetchPypi
, pytest, setuptools-git, pytest-shutil, pytest-fixture-config, psutil
, requests, future }:

buildPythonPackage rec {
  pname = "pytest-server-fixtures";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "902607675ce2ee09bdc72381b4470f79504fc131afdc15174e49a84d031760df";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ setuptools-git pytest-shutil pytest-fixture-config psutil requests future ];

  # RuntimeError: Unable to find a free server number to start Xvfb
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Extensible server fixures for py.test";
    homepage  = "https://github.com/manahl/pytest-plugins";
    license = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
  };
}
