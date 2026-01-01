{
  lib,
  adlfs,
  appdirs,
  buildPythonPackage,
  databackend,
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
  setuptools-scm,
  setuptools,
  typing-extensions,
  xxhash,
}:

buildPythonPackage rec {
  pname = "pins";
  version = "0.9.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "rstudio";
    repo = "pins-python";
    tag = "v${version}";
    hash = "sha256-fDbgas4RG4cJRqrISWmrMUQUycQindlqF9/jA5R1TF8=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    appdirs
    databackend
    fsspec
    humanize
    importlib-metadata
    importlib-resources
    jinja2
    joblib
    pandas
    pyyaml
    requests
    typing-extensions
    xxhash
  ];

  optional-dependencies = {
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
  ]
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;
=======
  ++ lib.flatten (builtins.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  pythonImportsCheck = [ "pins" ];

  enabledTestPaths = [ "pins/tests/" ];

  disabledTestPaths = [
    # Tests require network access
    "pins/tests/test_boards.py"
    "pins/tests/test_compat.py"
    "pins/tests/test_constructors.py"
    "pins/tests/test_rsconnect_api.py"
  ];

<<<<<<< HEAD
  meta = {
    description = "Module to publishes data, models and other Python objects";
    homepage = "https://github.com/rstudio/pins-python";
    changelog = "https://github.com/rstudio/pins-python/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Module to publishes data, models and other Python objects";
    homepage = "https://github.com/rstudio/pins-python";
    changelog = "https://github.com/rstudio/pins-python/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
