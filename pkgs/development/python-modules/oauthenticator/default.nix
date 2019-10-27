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
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ce31c929bb456ad8734b9b8a7f539e44ab3afff07169e25e974ca576f4c836c";
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
    homepage =  https://github.com/jupyterhub/oauthenticator;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ixxie ];
  };
}
