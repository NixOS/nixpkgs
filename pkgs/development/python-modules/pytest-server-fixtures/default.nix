{ stdenv, buildPythonPackage, fetchPypi
, pytest, setuptools-git, pytest-shutil, pytest-fixture-config, psutil
, requests, future }:

buildPythonPackage rec {
  pname = "pytest-server-fixtures";
  version = "1.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cf4a6aff42f620fe556c175e8f493f086c9690a492059cf23521a10d3ac5db1a";
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
