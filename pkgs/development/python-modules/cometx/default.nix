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

buildPythonPackage rec {
  pname = "cometx";
  version = "3.6.7";

  pyproject = true;
  build-system = [ setuptools ];

  src = fetchFromGitHub {
    owner = "comet-ml";
    repo = "cometx";
    tag = version;
    hash = "sha256-7jq/W1IEu6RZhKHMWdGC9b3xCGnS4hrZIPcQZ2NpIt4=";
  };

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
    changelog = "https://github.com/comet-ml/cometx/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jherland ];
    mainProgram = "cometx";
  };
}
