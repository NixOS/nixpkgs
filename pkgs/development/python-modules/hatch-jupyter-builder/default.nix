{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-mock,
  pytestCheckHook,
  twine,
}:

buildPythonPackage rec {
  pname = "hatch-jupyter-builder";
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyterlab";
    repo = "hatch-jupyter-builder";
    tag = "v${version}";
    hash = "sha256-QDWHVdjtexUNGRL+dVehdBwahSW2HmNkZKkQyuOghyI=";
  };

  build-system = [ hatchling ];

  dependencies = [ hatchling ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
    twine
  ];

  disabledTests = [
    # tests pip install, which unsurprisingly fails
    "test_hatch_build"
  ];

  meta = {
    changelog = "https://github.com/jupyterlab/hatch-jupyter-builder/releases/tag/v${version}";
    description = "Hatch plugin to help build Jupyter packages";
    mainProgram = "hatch-jupyter-builder";
    homepage = "https://github.com/jupyterlab/hatch-jupyter-builder";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
