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
      --replace-fail "'pytest-runner'" ""
    substituteInPlace pyproject.toml \
      --replace-fail "numpy==" "numpy>="
  '';

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests/mrsqm"
  ];

  pythonImportsCheck = [ "mrsqm" ];

  meta = {
    description = "MrSQM (Multiple Representations Sequence Miner) is a time series classifier";
    homepage = "https://pypi.org/project/mrsqm";
    changelog = "https://github.com/mlgig/mrsqm/releases/tag/v.${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ mbalatsko ];
  };
}
