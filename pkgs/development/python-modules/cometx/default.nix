{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  comet-ml,
  ipython,
  matplotlib,
  numpy,
  requests,
  scipy,
  selenium,
  urllib3,
  zipfile2,
  tqdm,
  reportlab,
  streamlit,
  boto3,
}:

buildPythonPackage (finalAttrs: {
  pname = "cometx";
  version = "3.6.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "comet-ml";
    repo = "cometx";
    tag = finalAttrs.version;
    hash = "sha256-pt+aa4FgPl7Rm+Xr0AglSZtmbXx8cOeh5xTptLHmMF0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    comet-ml
    ipython
    matplotlib
    numpy
    requests
    scipy
    selenium
    urllib3
    zipfile2
    tqdm
    reportlab
    streamlit
    boto3
  ];

  # WARNING: Running the tests will create experiments, models, assets, etc.
  # on your Comet account.
  doCheck = false;

  pythonImportsCheck = [ "cometx" ];

  meta = {
    description = "Open source extensions for the Comet SDK";
    homepage = "https://github.com/comet-ml/comet-sdk-extensions/";
    changelog = "https://github.com/comet-ml/cometx/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jherland ];
    mainProgram = "cometx";
  };
})
