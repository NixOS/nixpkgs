{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  click,
  joblib,
  loguru,
  matplotlib,
  numpy,
  pandas,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-mock,
  pytest-timeout,
  pytest-xdist,
  rich-click,
  scipy,
  tqdm,
}:

buildPythonPackage rec {
  pname = "fitter";
  version = "1.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cokelaer";
    repo = "fitter";
    rev = "refs/tags/v${version}";
    hash = "sha256-RNcI8N2Eiemu37pbkWen681ZVsmuEHqY5GmmF522kDo=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    click
    joblib
    loguru
    matplotlib
    numpy
    pandas
    rich-click
    scipy
    tqdm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-mock
    pytest-timeout
    pytest-xdist
  ];

  pythonImportsCheck = [
    "fitter"
  ];

  meta = {
    description = "Fit data to many distributions";
    homepage = "https://github.com/cokelaer/fitter";
    changelog = "https://github.com/cokelaer/fitter/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ShamrockLee ];
    mainProgram = "fitter";
  };
}
