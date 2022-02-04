{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi

# build dependencies
, setuptools-scm

# dependencies
, django

# tests
, geopy
, nose
, pysolr
, python-dateutil
, requests
, whoosh
}:

buildPythonPackage rec {
  pname = "django-haystack";
  version = "3.1.1";
  format = "setuptools";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6d05756b95d7d5ec1dbd4668eb999ced1504b47f588e2e54be53b1404c516a82";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "geopy==" "geopy>="
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    django
  ];

  checkInputs = [
    geopy
    nose
    pysolr
    python-dateutil
    requests
    whoosh
  ];

  meta = with lib; {
    description = "Pluggable search for Django";
    homepage = "http://haystacksearch.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
