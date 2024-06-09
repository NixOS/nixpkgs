{
  lib,
  adlfs,
  appdirs,
  buildPythonPackage,
  fastparquet,
  fetchFromGitHub,
  fsspec,
  gcsfs,
  humanize,
  importlib-metadata,
  importlib-resources,
  jinja2,
  joblib,
  pandas,
  pyarrow,
  pytest-cases,
  pytest-parallel,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  requests,
  s3fs,
  setuptools,
  setuptools-scm,
  xxhash,
}:

buildPythonPackage rec {
  pname = "pins";
  version = "0.8.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "rstudio";
    repo = "pins-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-TRwdd0vxqXZgongjooJG5rzTnopUsjfl2I8z3nBocdg=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    appdirs
    fsspec
    humanize
    importlib-metadata
    importlib-resources
    jinja2
    joblib
    pandas
    pyyaml
    requests
    xxhash
  ];

  passthru.optional-dependencies = {
    aws = [ s3fs ];
    azure = [ adlfs ];
    gcs = [ gcsfs ];
  };

  nativeCheckInputs = [
    fastparquet
    pyarrow
    pytest-cases
    pytest-parallel
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [ "pins" ];

  pytestFlagsArray = [ "pins/tests/" ];

  disabledTestPaths = [
    # Tests require network access
    "pins/tests/test_boards.py"
    "pins/tests/test_compat.py"
    "pins/tests/test_constructors.py"
    "pins/tests/test_rsconnect_api.py"
  ];

  meta = with lib; {
    description = "Module to publishes data, models and other Python objects";
    homepage = "https://github.com/rstudio/pins-python";
    changelog = "https://github.com/rstudio/pins-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
