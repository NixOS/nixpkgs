{ buildPythonPackage
, fetchPypi
, fetchpatch
, lib
, pexpect
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-timeout";
  version = "1.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cczcjhw4xx5sjkhxlhc5c1bkr7x6fcyx12wrnvwfckshdvblc2a";
  };

  patches = fetchpatch {
    url = https://bitbucket.org/pytest-dev/pytest-timeout/commits/36998c891573d8ec1db1acd4f9438cb3cf2aee2e/raw;
    sha256 = "05zc2w7mjgv8rm8i1cbxp7k09vlscmay5iy78jlzgjqkrx3wkf46";
  };

  checkInputs = [ pytest pexpect ];
  checkPhase = ''
    # test_suppresses_timeout_when_pdb_is_entered fails under heavy load
    pytest -ra -k 'not test_suppresses_timeout_when_pdb_is_entered'
  '';

  meta = with lib;{
    description = "py.test plugin to abort hanging tests";
    homepage = https://bitbucket.org/pytest-dev/pytest-timeout/;
    license = licenses.mit;
    maintainers = with maintainers; [ makefu costrouc ];
  };
}
