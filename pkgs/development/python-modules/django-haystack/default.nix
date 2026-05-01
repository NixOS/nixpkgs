{
  lib,
  buildPythonPackage,
  django,
  elasticsearch,
  fetchPypi,
  geopy,
  packaging,
  pysolr,
  python-dateutil,
  requests,
  setuptools-scm,
  setuptools,
  stdenv,
  whoosh,
}:

buildPythonPackage rec {
  pname = "django-haystack";
  version = "3.3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "django_haystack";
    inherit version;
    hash = "sha256-487ta4AAYl2hTUCetNrGmJSQXirIrBj5v9tZMjygLqs=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [ django ];

  dependencies = [ packaging ];

  optional-dependencies = {
    elasticsearch = [ elasticsearch ];
  };

  # tests fail and get stuck on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  nativeCheckInputs = [
    geopy
    pysolr
    python-dateutil
    requests
    whoosh
  ]
  ++ optional-dependencies.elasticsearch;

  checkPhase = ''
    runHook preCheck
    python test_haystack/run_tests.py
    runHook postCheck
  '';

  meta = {
    description = "Pluggable search for Django";
    homepage = "http://haystacksearch.org/";
    changelog = "https://github.com/django-haystack/django-haystack/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
