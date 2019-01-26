{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytestcov, mock, cmdline, pytest-fixture-config, pytest-shutil }:

buildPythonPackage rec {
  pname = "pytest-virtualenv";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8d8a0b9b57f5efb7db6457c1f57347e35fe332979ecefe592d5324430ae3ed7f";
  };

  buildInputs = [ pytest pytestcov mock cmdline ];
  propagatedBuildInputs = [ pytest-fixture-config pytest-shutil ];
  checkPhase = '' py.test tests/unit '';

  meta = with stdenv.lib; {
    description = "Create a Python virtual environment in your test that cleans up on teardown. The fixture has utility methods to install packages and list what’s installed.";
    homepage = https://github.com/manahl/pytest-plugins;
    license = licenses.mit;
    maintainers = with maintainers; [ ryansydnor ];
  };
}
