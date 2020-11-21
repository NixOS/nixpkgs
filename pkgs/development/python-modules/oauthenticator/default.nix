{ lib
, buildPythonPackage
, jupyterhub
, globus-sdk
, mwoauth
, codecov
, flake8
, pyjwt
, pytest
, pytestcov
, pytest-tornado
, requests-mock
, pythonOlder
, fetchPypi
}:

buildPythonPackage rec {
  pname = "oauthenticator";
  version = "0.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f4a048e329766a6023768c9fefd77c859a9726bdf2029c62ec78de410ec876cd";
  };

  checkPhase = ''
    py.test oauthenticator/tests
  '';

  # No tests in archive
  doCheck = false;

  checkInputs = [  globus-sdk mwoauth codecov flake8 pytest
    pytestcov pytest-tornado requests-mock pyjwt ];

  propagatedBuildInputs = [ jupyterhub ];

  disabled = pythonOlder "3.4";

  meta = with lib; {
    description = "Authenticate JupyterHub users with common OAuth providers, including GitHub, Bitbucket, and more.";
    homepage =  "https://github.com/jupyterhub/oauthenticator";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ixxie ];
  };
}
