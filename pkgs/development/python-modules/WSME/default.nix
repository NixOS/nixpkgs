{ lib, buildPythonPackage, fetchPypi, isPy3k
, pbr, six, simplegeneric, netaddr, pytz, webob
, cornice, nose, webtest, pecan, transaction, cherrypy, sphinx
, flask, flask-restful, suds-jurko, glibcLocales }:

buildPythonPackage rec {
  pname = "WSME";
  version = "0.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "965b9ce48161e5c50d84aedcf50dca698f05bf07e9d489201bccaec3141cd304";
  };

  postPatch = ''
    # remove turbogears tests as we don't have it packaged
    rm tests/test_tg*
    # WSME seems incompatible with recent SQLAlchemy version
    rm wsmeext/tests/test_sqlalchemy*
    # https://bugs.launchpad.net/wsme/+bug/1510823
    ${if isPy3k then "rm tests/test_cornice.py" else ""}
  '';

  checkPhae = ''
    nosetests --exclude test_buildhtml \
              --exlcude test_custom_clientside_error \
              --exclude test_custom_non_http_clientside_error
  '';

  # UnicodeEncodeError, ImportError, ...
  doCheck = !isPy3k;

  nativeBuildInputs = [ pbr ];

  propagatedBuildInputs = [
    six simplegeneric netaddr pytz webob
  ];

  checkInputs = [
    cornice nose webtest pecan transaction cherrypy sphinx
    flask flask-restful suds-jurko glibcLocales
  ];

  meta = with lib; {
    broken = true;
    description = "Simplify the writing of REST APIs, and extend them with additional protocols";
    homepage = "http://git.openstack.org/cgit/openstack/wsme";
    license = licenses.mit;
  };
}
