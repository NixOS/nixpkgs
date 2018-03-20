{ lib, buildPythonPackage, fetchPypi, isPy3k
, pbr, six, simplegeneric, netaddr, pytz, webob
, cornice, nose, webtest, pecan, transaction, cherrypy, sphinx }:

buildPythonPackage rec {
  pname = "WSME";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nw827iz5g9jlfnfbdi8kva565v0kdjzba2lccziimj09r71w900";
  };

  checkPhase = ''
    # remove turbogears tests as we don't have it packaged
    rm tests/test_tg*
    # remove flask since we don't have flask-restful
    rm tests/test_flask*
    # https://bugs.launchpad.net/wsme/+bug/1510823
    ${if isPy3k then "rm tests/test_cornice.py" else ""}

    nosetests tests/
  '';

  nativeBuildInputs = [ pbr ];

  propagatedBuildInputs = [
    six simplegeneric netaddr pytz webob
  ];

  checkInputs = [
    cornice nose webtest pecan transaction cherrypy sphinx
  ];

  meta = with lib; {
    description = "Simplify the writing of REST APIs, and extend them with additional protocols";
    homepage = http://git.openstack.org/cgit/openstack/wsme;
    license = licenses.mit;
  };
}
