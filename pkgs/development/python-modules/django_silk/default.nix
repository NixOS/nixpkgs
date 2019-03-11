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
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bce0e35d2a6ec3688a0c062c6964695beef4a452be48085f2c1e25f685652d9d";
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
