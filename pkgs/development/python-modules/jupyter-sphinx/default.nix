{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  ipykernel,
  ipython,
  ipywidgets,
  nbconvert,
  nbformat,
  sphinx,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "jupyter-sphinx";
  version = "0.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyter";
    repo = "jupyter-sphinx";
    tag = "v${version}";
    hash = "sha256-o/i3WravKZPf7uw2H4SVYfAyaZGf19ZJlkmeHCWcGtE=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    ipykernel
    ipython
    ipywidgets
    nbconvert
    nbformat
    sphinx
  ];

  pythonImportsCheck = [ "jupyter_sphinx" ];

  env.JUPYTER_PLATFORM_DIRS = 1;

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # https://github.com/jupyter/jupyter-sphinx/issues/280"
    "test_builder_priority"
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Jupyter Sphinx Extensions";
    homepage = "https://github.com/jupyter/jupyter-sphinx/";
    changelog = "https://github.com/jupyter/jupyter-sphinx/releases/tag/v${version}";
    license = lib.licenses.bsd3;
  };
}
