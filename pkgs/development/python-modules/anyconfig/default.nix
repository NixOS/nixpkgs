{ buildPythonPackage
, fetchPypi
, lib
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "anyconfig";
  version = "0.14.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LN9Ur12ujpF0Pe2CxU7Z2Krvo6lyL11F6bX3S2A+AU0=";
  };

  postPatch = ''
    sed -i '/addopts =/d' setup.cfg
  '';

  propagatedBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # OSError: /build/anyconfig-0.12.0/tests/res/cli/no_template/10/e/10.* should exists but not
    "test_runs_for_datasets"
  ];

  disabledTestPaths = [
    # NameError: name 'TT' is not defined
    "tests/schema/test_jsonschema.py"
    "tests/backend/loaders/pickle/test_pickle_stdlib.py"
  ];

  pythonImportsCheck = [ "anyconfig" ];

  meta = with lib; {
    description = "Python library provides common APIs to load and dump configuration files in various formats";
    mainProgram = "anyconfig_cli";
    homepage = "https://github.com/ssato/python-anyconfig";
    license = licenses.mit;
    maintainers = with maintainers; [ tboerger ];
  };
}
