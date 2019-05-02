{ stdenv
, buildPythonPackage
, fetchPypi
, django
, pygments
, simplejson
, dateutil
, requests
, sqlparse
, jinja2
, autopep8
, pytz
, pillow
, mock
}:

buildPythonPackage rec {
  pname = "django-silk";
  version = "3.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8dd5b78531360bd8c3d571384f9f4f82ef03e1764e30dd4621c5638f5c973a1d";
  };

  doCheck = false;

  buildInputs = [ mock ];
  propagatedBuildInputs = [ django pygments simplejson dateutil requests sqlparse jinja2 autopep8 pytz pillow ];

  meta = with stdenv.lib; {
    description = "Silky smooth profiling for the Django Framework";
    homepage = https://github.com/mtford90/silk;
    license = licenses.mit;
  };

}
