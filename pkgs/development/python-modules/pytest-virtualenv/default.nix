{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytestcov, mock, cmdline, pytest-fixture-config, pytest-shutil }:

buildPythonPackage rec {
  pname = "pytest-virtualenv";
  version = "1.2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mb76zhlak4qjjq2h7kaxbihk1b9plmimbzcb8qv4906cxl69ysi";
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
