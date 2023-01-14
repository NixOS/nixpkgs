{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, hatch
, pytest-mock
, pytestCheckHook
, tomli
, twine
}:

buildPythonPackage rec {
  pname = "hatch-jupyter-builder";
  version = "0.8.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jupyterlab";
    repo = "hatch-jupyter-builder";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ns5jrVfTAA7NuvUok3/13nIpXSSVZ6WRkgHyTuxkSKA=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  checkInputs = [
    hatch
    pytest-mock
    pytestCheckHook
    tomli
    twine
  ];

  disabledTests = [
    # tests pip install, which unsuprisingly fails
    "test_hatch_build"
  ];

  meta = with lib; {
    changelog = "https://github.com/jupyterlab/hatch-jupyter-builder/releases/tag/v${version}";
    description = "hatch plugin to help build Jupyter packages";
    homepage = "https://github.com/jupyterlab/hatch-jupyter-builder";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
