{ buildPythonPackage
, fetchPypi
, fetchpatch
, lib
, pexpect
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-timeout";
  version = "1.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xnsigs0kmpq1za0d4i522sp3f71x5bgpdh3ski0rs74yqy13cr0";
  };

  checkInputs = [ pytest pexpect ];
  checkPhase = ''
    # test_suppresses_timeout_when_pdb_is_entered fails under heavy load
    pytest -ra -k 'not test_suppresses_timeout_when_pdb_is_entered and not test_cov'
  '';

  meta = with lib;{
    description = "py.test plugin to abort hanging tests";
    homepage = "https://bitbucket.org/pytest-dev/pytest-timeout/";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu costrouc ];
  };
}
