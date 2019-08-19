{ stdenv
, buildPythonPackage
, fetchPypi
, pytz
, requests
, coverage
, mock
, nose
, unittest2
, requests-kerberos
, codecov
, tox
, pylint
, pycodestyle
, pytest
, pytestcov
, pytest-mock
}:

buildPythonPackage rec {
  pname = "jenkinsapi";
  version = "0.3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bf35b208fe05e65508f3b8bbb0f91d164b007632e27ebe5f54041174b681b696";
  };

  patchPhase = ''
    # Removing unpure tests
    rm -fr jenkinsapi_tests/systests/conftest.py jenkinsapi_tests/unittests
    substituteInPlace test-requirements.txt \
      --replace "pytest==3.7.0" "pytest"
  '';


  propagatedBuildInputs = [ pytz requests ];
  checkInputs = [
    requests-kerberos
    codecov
    tox
    pylint
    pycodestyle
    coverage
    mock
    nose
    unittest2
    pytest
    pytestcov
    pytest-mock
  ];

  meta = with stdenv.lib; {
    description = "A Python API for accessing resources on a Jenkins continuous-integration server";
    homepage = https://github.com/salimfadhley/jenkinsapi;
    maintainers = with maintainers; [ drets ];
    license = licenses.mit;
  };

}
