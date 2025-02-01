{
  lib,
  fetchPypi,
  buildPythonPackage,
  fetchpatch,
  dask,
  urllib3,
  geojson,
  verlib2,
  pueblo,
  pandas,
  pythonOlder,
  sqlalchemy,
  pytestCheckHook,
  pytz,
}:

buildPythonPackage rec {
  pname = "crate";
  version = "0.35.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4hGACtsK71hvcn8L9ggID7zR+umtTwvskBxSHBpLyME=";
  };
  patches = [
    # Fix a pandas issue https://github.com/crate/crate-python/commit/db7ba4d0e1f4f4087739a8f9ebe1d71946333979
    (fetchpatch {
      url = "https://github.com/crate/crate-python/commit/db7ba4d0e1f4f4087739a8f9ebe1d71946333979.patch";
      hash = "sha256-20g8T0t5gPMbK6kRJ2bzc4BNbB1Dg4hvngXNUPvxi5I=";
      name = "python-crate-fix-pandas-error.patch";
      # Patch doesn't apply due to other changes to these files
      excludes = [
        "setup.py"
        "docs/by-example/sqlalchemy/dataframe.rst"
      ];
    })
  ];

  propagatedBuildInputs = [
    urllib3
    sqlalchemy
    geojson
    verlib2
    pueblo
  ];

  nativeCheckInputs = [
    dask
    pandas
    pytestCheckHook
    pytz
  ];

  disabledTests = [
    # the following tests require network access
    "test_layer_from_uri"
    "test_additional_settings"
    "test_basic"
    "test_cluster"
    "test_default_settings"
    "test_dynamic_http_port"
    "test_environment_variables"
    "test_verbosity"
  ];

  disabledTestPaths = [
    # imports setuptools.ssl_support, which doesn't exist anymore
    "src/crate/client/test_http.py"
  ];

  meta = with lib; {
    homepage = "https://github.com/crate/crate-python";
    description = "A Python client library for CrateDB";
    changelog = "https://github.com/crate/crate-python/blob/${version}/CHANGES.txt";
    license = licenses.asl20;
    maintainers = with maintainers; [ doronbehar ];
  };
}
