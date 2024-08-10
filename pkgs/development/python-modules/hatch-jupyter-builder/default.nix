{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-mock,
  pytestCheckHook,
  tomli,
  twine,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "hatch-jupyter-builder";
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyterlab";
    repo = "hatch-jupyter-builder";
    rev = "refs/tags/v${version}";
    hash = "sha256-QDWHVdjtexUNGRL+dVehdBwahSW2HmNkZKkQyuOghyI=";
  };

  build-system = [ hatchling ];

  dependencies = [ hatchling ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
    twine
  ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  disabledTests = [
    # tests pip install, which unsuprisingly fails
    "test_hatch_build"
  ];

  meta = with lib; {
    changelog = "https://github.com/jupyterlab/hatch-jupyter-builder/releases/tag/v${version}";
    description = "hatch plugin to help build Jupyter packages";
    mainProgram = "hatch-jupyter-builder";
    homepage = "https://github.com/jupyterlab/hatch-jupyter-builder";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
