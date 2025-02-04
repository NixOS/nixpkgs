{
  stdenv,
  lib,
  pythonOlder,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  scipy,
  pandas,
  matplotlib,
  nbval,
  pyvisa,
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
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "scikit-rf";
  version = "1.5.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "scikit-rf";
    repo = "scikit-rf";
    tag = "v${version}";
    hash = "sha256-WUrZHKWxXc1z5IrKD52MQfTEGHnoqm/AarSZOANffpc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--cov=skrf" ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    numpy
    scipy
    pandas
  ];

  optional-dependencies = {
    plot = [ matplotlib ];
    xlsx = [ openpyxl ];
    netw = [ networkx ];
    visa = [ pyvisa ];
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
    pyvisa
    openpyxl
    networkx
    pytestCheckHook
  ];

  # test_calibration.py generates a divide by zero error on darwin
  # https://github.com/scikit-rf/scikit-rf/issues/972
  disabledTestPaths = lib.optional (
    stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isDarwin
  ) "skrf/calibration/tests/test_calibration.py";

  pythonImportsCheck = [ "skrf" ];

  meta = with lib; {
    description = "Python library for RF/Microwave engineering";
    homepage = "https://scikit-rf.org/";
    changelog = "https://github.com/scikit-rf/scikit-rf/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lugarun ];
  };
}
