{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  pythonAtLeast,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "anyconfig";
  version = "0.14.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ssato";
    repo = "python-anyconfig";
    tag = "RELEASE_${finalAttrs.version}";
    hash = "sha256-ngXj/KzErz81T09j6tlV9OYDX3DqW5I8xo/ulLNokpQ=";
  };

  postPatch = ''
    sed -i '/addopts =/d' setup.cfg
  '';

  propagatedBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # OSError: /build/anyconfig-0.12.0/tests/res/cli/no_template/10/e/10.* should exists but not
    "test_runs_for_datasets"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # Python 3.14: output format has changed
    "test_dumps"
    "test_dump"
  ];

  disabledTestPaths = [
    # NameError: name 'TT' is not defined
    "tests/schema/test_jsonschema.py"
    "tests/backend/loaders/pickle/test_pickle_stdlib.py"
  ];

  pythonImportsCheck = [ "anyconfig" ];

  meta = {
    description = "Python library provides common APIs to load and dump configuration files in various formats";
    mainProgram = "anyconfig_cli";
    homepage = "https://github.com/ssato/python-anyconfig";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tboerger ];
  };
})
