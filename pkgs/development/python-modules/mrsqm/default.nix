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
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "mrsqm";
  version = "0.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mlgig";
    repo = "mrsqm";
    tag = "v.${finalAttrs.version}";
    hash = "sha256-5K6vCU0HExnmYNThZNDCbEtII9bUGauxDtKkJXe/85Q=";
  };

  patches = [
    # Fixes for changes to the SKLearn API
    ./sklearn-fixes.patch
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "setup_requires=['pytest-runner']," ""
    substituteInPlace pyproject.toml \
      --replace-fail "numpy==" "numpy>="
  '';

  build-system = [
    setuptools
    cython
  ];

  buildInputs = [ fftw ];

  dependencies = [
    pandas
    scikit-learn
    numpy
    pip
  ];

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  enabledTestPaths = [
    "tests/mrsqm"
  ];

  pythonImportsCheck = [ "mrsqm" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "v\\.(.*)"
    ];
  };

  meta = {
    description = "MrSQM (Multiple Representations Sequence Miner) is a time series classifier";
    homepage = "https://pypi.org/project/mrsqm";
    changelog = "https://github.com/mlgig/mrsqm/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
})
