{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi

# build dependencies
, setuptools
, setuptools-scm

# dependencies
, django

# tests
, elasticsearch
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
  format = "pyproject";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-l+MZeu/CJf5AW28XYAolNL+CfLTWdDEwwgvBoG9yk6Q=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "geopy==" "geopy>="
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [
    django
  ];

  passthru.optional-dependencies = {
    elasticsearch = [
      elasticsearch
    ];
  };

  doCheck = lib.versionOlder django.version "4";

  nativeCheckInputs = [
    geopy
    nose
    pysolr
    python-dateutil
    requests
    whoosh
  ]
  ++ passthru.optional-dependencies.elasticsearch;

  checkPhase = ''
    runHook preCheck
    python test_haystack/run_tests.py
    runHook postCheck
  '';

  meta = with lib; {
    description = "Pluggable search for Django";
    homepage = "http://haystacksearch.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
