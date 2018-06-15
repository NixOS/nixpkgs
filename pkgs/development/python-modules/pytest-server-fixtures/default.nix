{ stdenv, buildPythonPackage, fetchPypi
, pytest, setuptools-git, pytest-shutil, pytest-fixture-config, psutil
, requests, future }:

buildPythonPackage rec {
  pname = "pytest-server-fixtures";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "21eef04612ed42f73534c45ddbaef8458c800809354a5f5a96a8fde88b2a97e7";
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
