{ buildPythonPackage
, lib
, fetchPypi
, setuptools
, formulaic
, click
, num2words
, numpy
, scipy
, pandas
, nibabel
, bids-validator
, sqlalchemy
, pytestCheckHook
, versioneer
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "pybids";
  version = "0.16.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pahl8wi6Sf8AuVqkvi7H90ViHr+9utb14ZVmKK3rFm4=";
  };

  pythonRelaxDeps = [
    "formulaic"
    "sqlalchemy"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
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

  pythonImportsCheck = [
    "bids"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # looks for missing data:
    "test_config_filename"
    # regression associated with formulaic >= 0.6.0
    # (see https://github.com/bids-standard/pybids/issues/1000)
    "test_split"
  ];

  meta = with lib; {
    description = "Python tools for querying and manipulating BIDS datasets";
    homepage = "https://github.com/bids-standard/pybids";
    changelog = "https://github.com/bids-standard/pybids/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
