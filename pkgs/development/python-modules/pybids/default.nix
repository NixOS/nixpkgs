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
  pytestCheckHook,
  versioneer,
}:

buildPythonPackage rec {
  pname = "pybids";
  version = "0.16.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5MAp5CYlOh1WxsXOE/LHVNm/K4VGFaLKWaaKYwKjQIM=";
  };

  pythonRelaxDeps = [
    "formulaic"
    "sqlalchemy"
  ];

  nativeBuildInputs = [
    setuptools
    versioneer
  ] ++ versioneer.optional-dependencies.toml;

  propagatedBuildInputs = [
    bids-validator
    click
    formulaic
    nibabel
    num2words
    numpy
    pandas
    scipy
    sqlalchemy
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

  meta = with lib; {
    description = "Python tools for querying and manipulating BIDS datasets";
    homepage = "https://github.com/bids-standard/pybids";
    changelog = "https://github.com/bids-standard/pybids/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "pybids";
  };
}
