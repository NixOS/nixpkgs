{ stdenv, buildPythonPackage, fetchPypi
, pytest_3, pytestcov, mock, cmdline, pytest-fixture-config, pytest-shutil }:

buildPythonPackage rec {
  pname = "pytest-virtualenv";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d281725d10848773cb2b495d1255dd0a42fc9179e34a274c22e1c35837721f19";
  };

  checkInputs = [ pytest_3 pytestcov mock cmdline ];
  propagatedBuildInputs = [ pytest-fixture-config pytest-shutil ];
  checkPhase = '' py.test tests/unit '';

  nativeBuildInputs = [ pytest_3 ];

  meta = with stdenv.lib; {
    description = "Create a Python virtual environment in your test that cleans up on teardown. The fixture has utility methods to install packages and list what’s installed.";
    homepage = https://github.com/manahl/pytest-plugins;
    license = licenses.mit;
    maintainers = with maintainers; [ ryansydnor ];
  };
}
