{ lib
, buildPythonPackage
, fetchPypi
, pythonAtLeast
, pbr
, six
, simplegeneric
, netaddr
, pytz
, webob
# Test inputs
, cherrypy
, flask
, flask-restful
, glibcLocales
, nose
, pecan
, sphinx
, transaction
, webtest
}:

buildPythonPackage rec {
  pname = "WSME";
  version = "0.10.1";

  disabled = pythonAtLeast "3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "34209b623635a905bcdbc654f53ac814d038da65e4c2bc070ea1745021984079";
  };

  nativeBuildInputs = [ pbr ];

  propagatedBuildInputs = [
    netaddr
    pytz
    simplegeneric
    six
    webob
  ];

  checkInputs = [
    nose
    cherrypy
    flask
    flask-restful
    glibcLocales
    pecan
    sphinx
    transaction
    webtest
  ];

  # from tox.ini, tests don't work with pytest
  checkPhase = ''
    nosetests wsme/tests tests/pecantest tests/test_sphinxext.py tests/test_flask.py --verbose
  '';

  meta = with lib; {
    description = "Simplify the writing of REST APIs, and extend them with additional protocols";
    homepage = "https://pythonhosted.org/WSME/";
    changelog = "https://pythonhosted.org/WSME/changes.html";
    license = licenses.mit;
  };
}
