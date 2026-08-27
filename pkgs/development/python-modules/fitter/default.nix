{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-mock,
  pytest-timeout,
  pytest-xdist,
  writableTmpDirAsHomeHook,
  click,
  joblib,
  loguru,
  matplotlib,
  numpy,
  pandas,
  rich-click,
  scipy,
  tqdm,
}:

buildPythonPackage (finalAttrs: {
  __structuredAttrs = true;
  pname = "fitter";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cokelaer";
    repo = "fitter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TwCyP71fYJuF40KqbTyBtRY+NTDXF7WdqVR2hZY00oA=";
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

  env = {
    # Use the non-interactive matplotlib backend Agg.
    # Matplotlib doesn't switch backends smartly on Darwin builders
    # and aborts in the sandbox after WindowServer connection failed.
    MPLBACKEND = "Agg";
  };

  pythonImportsCheck = [
    "fitter"
  ];

  meta = {
    description = "Fit data to many distributions";
    homepage = "https://github.com/cokelaer/fitter";
    changelog = "https://github.com/cokelaer/fitter/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ShamrockLee ];
    mainProgram = "fitter";
  };
})
