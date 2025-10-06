{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  importlib-resources,
  pygments,
  tqdm,
  flask,
  multiprocess,
  docutils,
  sphinx,
  sphinx-autodoc-typehints,
  sphinx-rtd-theme,
  sphinx-versions,
  sphinxcontrib-images,
  ipywidgets,
  numpy,
  rich,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mpire";
  version = "2.10.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sybrenjansen";
    repo = "mpire";
    tag = "v${version}";
    hash = "sha256-6O+k8gSMCu4zhj7KzbsC5UUCU/TG/g3dYsGVuvcy25E=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    importlib-resources
    pygments
    tqdm
  ];

  optional-dependencies = {
    dashboard = [
      flask
    ];
    dill = [
      multiprocess
    ];
    docs = [
      docutils
      sphinx
      sphinx-autodoc-typehints
      sphinx-rtd-theme
      sphinx-versions
      sphinxcontrib-images
    ];
    testing = [
      ipywidgets
      multiprocess
      numpy
      rich
    ];
  };

  pythonImportsCheck = [
    "mpire"
  ];

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.testing;

  enabledTestPaths = [ "tests" ];

  meta = {
    description = "Python package for easy multiprocessing, but faster than multiprocessing";
    homepage = "https://pypi.org/project/mpire/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ booxter ];
  };
}
