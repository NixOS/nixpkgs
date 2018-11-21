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
  version = "0.5.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "845abc688738858ce06e993c4b7dbbcfcecf33029e828f143463ff96f9a78947";
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
