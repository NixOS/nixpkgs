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
  version = "0.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ff1b4ba2458a6ee460c3c4161d780a12e94811b2daaa5d13acdb354fa21a9916";
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
