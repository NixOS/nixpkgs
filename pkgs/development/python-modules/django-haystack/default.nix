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
  version = "3.2.1";
  format = "setuptools";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-l+MZeu/CJf5AW28XYAolNL+CfLTWdDEwwgvBoG9yk6Q=";
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

  nativeCheckInputs = [
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
