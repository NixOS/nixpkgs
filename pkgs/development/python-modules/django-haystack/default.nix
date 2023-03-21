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
, pytestCheckHook
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
    hash = "sha256-l+MZeu/CJf5AW28XYAolNL+CfLTWdDEwwgvBoG9yk6Q=";
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
    pytestCheckHook
    pysolr
    python-dateutil
    requests
    whoosh
  ];

  disabledTestPaths = [
    # Failing tests
    "test_haystack/test_app_loading.py"
    "test_haystack/test_fields.py"
    "test_haystack/test_forms.py"
    "test_haystack/test_indexes.py"
    "test_haystack/test_managers.py"
    "test_haystack/test_models.py"
    "test_haystack/test_query.py"
    "test_haystack/test_utils.py"
    "test_haystack/test_views.py"
    "test_haystack/elasticsearch*"
    "test_haystack/solr_tests/*"
    "test_haystack/simple_tests/test_simple_backend.py"
    "test_haystack/spatial/test_spatial.py"
    "test_haystack/whoosh_tests/test_forms.py"
    "test_haystack/whoosh_tests/test_whoosh_backend.py"
    "test_haystack/whoosh_tests/test_whoosh_query.py"

    # Spawns a process which never stops, causing timeouts on Hydra
    "test_haystack/whoosh_tests/test_whoosh_management_commands.py"
  ];

  meta = with lib; {
    description = "Pluggable search for Django";
    homepage = "http://haystacksearch.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
