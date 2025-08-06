{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
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

buildPythonPackage rec {
  pname = "mrsqm";
  version = "0.0.7";
  pyproject = true;

  build-system = [
    setuptools
  ];

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mlgig";
    repo = "mrsqm";
    tag = "v.${version}";
    hash = "sha256-5K6vCU0HExnmYNThZNDCbEtII9bUGauxDtKkJXe/85Q=";
  };

  buildInputs = [ fftw ];

  nativeBuildInputs = [ cython ];

  dependencies = [
    pandas
    scikit-learn
    numpy
    pip
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "setup_requires=['pytest-runner']," ""
    substituteInPlace pyproject.toml \
      --replace-fail "numpy==" "numpy>="
  '';

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
    changelog = "https://github.com/mlgig/mrsqm/releases/tag/v.${src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ mbalatsko ];
  };
}
