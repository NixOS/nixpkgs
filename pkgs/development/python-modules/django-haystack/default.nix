{ lib, buildPythonPackage, fetchPypi
, setuptools, setuptools-scm, django, python-dateutil, whoosh, pysolr
, coverage, mock, nose, geopy, requests }:

buildPythonPackage rec {
  pname = "django-haystack";
  version = "3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d490f920afa85471dd1fa5000bc8eff4b704daacbe09aee1a64e75cbc426f3be";
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
