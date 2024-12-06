{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  formulaic,
  click,
  num2words,
  numpy,
  scipy,
  pandas,
  nibabel,
  bids-validator,
  sqlalchemy,
  universal-pathlib,
  pytestCheckHook,
  versioneer,
}:

buildPythonPackage rec {
  pname = "pybids";
  version = "0.17.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4MpFXGh2uOHCjMa213CF6QzKCyEQNiN1moyNolEcySQ=";
  };

  pythonRelaxDeps = [
    "formulaic"
    "sqlalchemy"
  ];

  build-system = [
    setuptools
    versioneer
  ] ++ versioneer.optional-dependencies.toml;

  dependencies = [
    bids-validator
    click
    formulaic
    nibabel
    num2words
    numpy
    pandas
    scipy
    sqlalchemy
    universal-pathlib
  ];

  pythonImportsCheck = [ "bids" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Test looks for missing data
    "test_config_filename"
    # Regression associated with formulaic >= 0.6.0
    # (see https://github.com/bids-standard/pybids/issues/1000)
    "test_split"
    # AssertionError, TypeError
    "test_run_variable_collection_bad_length_to_df_all_dense_var"
    "test_extension_initial_dot"
    "test_to_df"
  ];

  meta = {
    description = "Python tools for querying and manipulating BIDS datasets";
    homepage = "https://github.com/bids-standard/pybids";
    changelog = "https://github.com/bids-standard/pybids/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wegank ];
    mainProgram = "pybids";
  };
}
