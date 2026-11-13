{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  scipy,
  pandas,
  matplotlib,
  nbval,
  pyvisa-py,
  networkx,
  ipython,
  ipykernel,
  ipywidgets,
  jupyter-client,
  sphinx-rtd-theme,
  sphinx,
  nbsphinx,
  openpyxl,
  setuptools,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-mock,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "scikit-rf";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-rf";
    repo = "scikit-rf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g8JDTGwvijnS0LJBHn50gdfahqMovs+A1uWDAyZdHu0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    scipy
    pandas
  ];

  pythonRemoveDeps = [ "pre-commit" ];

  optional-dependencies = {
    plot = [ matplotlib ];
    xlsx = [ openpyxl ];
    netw = [ networkx ];
    visa = [ pyvisa-py ];
    docs = [
      ipython
      ipykernel
      ipywidgets
      jupyter-client
      sphinx-rtd-theme
      sphinx
      nbsphinx
      openpyxl
      nbval
    ];
  };

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin { MPLBACKEND = "Agg"; };

  nativeCheckInputs = [
    pytest-mock
    matplotlib
    pyvisa-py
    openpyxl
    networkx
    pytestCheckHook
    pytest-cov-stub
    writableTmpDirAsHomeHook
  ];

  pytestFlags = [ "-Wignore::pytest.PytestUnraisableExceptionWarning" ];

  disabledTests = [
    # numpy.exceptions.VisibleDeprecationWarning: dtype(): align should be
    #  passed as Python or NumPy boolean but got `align=0`
    "test_constructor_from_pathlib"
    "test_constructor_from_pickle"
    "test_constructor_from_touchstone_special_encoding"
  ];

  pythonImportsCheck = [ "skrf" ];

  meta = {
    description = "Python library for RF/Microwave engineering";
    homepage = "https://scikit-rf.org/";
    changelog = "https://github.com/scikit-rf/scikit-rf/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ lugarun ];
  };
})
