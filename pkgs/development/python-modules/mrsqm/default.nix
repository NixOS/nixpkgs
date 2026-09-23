{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  fftw,
  pandas,
  scikit-learn,
  numpy,
  pip,
  setuptools,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mrsqm";
  version = "0.0.7";
  pyproject = true;
  __structuredAttrs = true;

  build-system = [
    setuptools
    cython
  ];

  src = fetchFromGitHub {
    owner = "mlgig";
    repo = "mrsqm";
    tag = "v.${finalAttrs.version}";
    hash = "sha256-5K6vCU0HExnmYNThZNDCbEtII9bUGauxDtKkJXe/85Q=";
  };

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
  ];

  # Include file only used at build time
  buildInputs = [
    fftw
  ];

  dependencies = [
    pandas
    scikit-learn
    numpy
    pip
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "setup_requires=['pytest-runner']," ""
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # all tests are broken
  doCheck = false;

  # enabledTestPaths = [
  #   "tests/mrsqm"
  # ];

  pythonImportsCheck = [ "mrsqm" ];

  meta = {
    description = "MrSQM (Multiple Representations Sequence Miner) is a time series classifier";
    homepage = "https://pypi.org/project/mrsqm";
    changelog = "https://github.com/mlgig/mrsqm/releases/tag/v.${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
})
