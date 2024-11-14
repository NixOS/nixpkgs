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
  pythonOlder,
  sphinx,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "jupyter-sphinx";
  version = "0.5.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jupyter";
    repo = "jupyter-sphinx";
    rev = "refs/tags/v${version}";
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

  meta = with lib; {
    description = "Jupyter Sphinx Extensions";
    homepage = "https://github.com/jupyter/jupyter-sphinx/";
    changelog = "https://github.com/jupyter/jupyter-sphinx/releases/tag/${lib.removePrefix "refs/tags/" src.rev}";
    license = licenses.bsd3;
  };
}
