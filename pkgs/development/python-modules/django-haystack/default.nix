{ lib, buildPythonPackage, fetchPypi
, setuptools, setuptools-scm, django, python-dateutil, whoosh, pysolr
, coverage, mock, nose, geopy, requests }:

buildPythonPackage rec {
  pname = "django-haystack";
  version = "3.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6d05756b95d7d5ec1dbd4668eb999ced1504b47f588e2e54be53b1404c516a82";
  };

  checkInputs = [ pysolr whoosh python-dateutil geopy coverage nose mock coverage requests ];
  propagatedBuildInputs = [ django setuptools ];
  nativeBuildInputs = [ setuptools-scm ];

  postPatch = ''
    sed -i 's/geopy==/geopy>=/' setup.py
  '';

  # ImportError: cannot import name django.contrib.gis.geos.prototypes
  doCheck = false;

  meta = with lib; {
    description = "Modular search for Django";
    homepage = "http://haystacksearch.org/";
    license = licenses.bsd3;
  };
}
