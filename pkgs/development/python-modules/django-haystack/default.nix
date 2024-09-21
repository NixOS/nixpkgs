{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,

  # build dependencies
  setuptools,
  setuptools-scm,

  # dependencies
  django,
  packaging,

  # tests
  elasticsearch,
  geopy,
  pysolr,
  python-dateutil,
  requests,
  whoosh,
}:

buildPythonPackage rec {
  pname = "django-haystack";
  version = "3.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.5";

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
  propagatedBuildInputs = [ packaging ];

  optional-dependencies = {
    elasticsearch = [ elasticsearch ];
  };

  nativeCheckInputs = [
    geopy
    pysolr
    python-dateutil
    requests
    whoosh
  ] ++ optional-dependencies.elasticsearch;


  checkPhase = ''
    runHook preCheck
    python test_haystack/run_tests.py
    runHook postCheck
  '';

  meta = with lib; {
    description = "Pluggable search for Django";
    homepage = "http://haystacksearch.org/";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
