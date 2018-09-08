{ lib, buildPythonPackage, fetchPypi
, setuptools_scm, django, dateutil, whoosh, pysolr
, coverage, mock, nose, geopy, requests }:

buildPythonPackage rec {
  pname = "django-haystack";
  version = "2.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8b54bcc926596765d0a3383d693bcdd76109c7abb6b2323b3984a39e3576028c";
  };

  checkInputs = [ pysolr whoosh dateutil geopy coverage nose mock coverage requests ];
  propagatedBuildInputs = [ django ];
  nativeBuildInputs = [ setuptools_scm ];

  postPatch = ''
    sed -i 's/geopy==/geopy>=/' setup.py
  '';

  # ImportError: cannot import name django.contrib.gis.geos.prototypes
  doCheck = false;

  meta = with lib; {
    description = "Modular search for Django";
    homepage = http://haystacksearch.org/;
    license = licenses.bsd3;
  };
}
