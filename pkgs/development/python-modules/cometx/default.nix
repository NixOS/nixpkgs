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
}:

buildPythonPackage rec {
  pname = "cometx";
  version = "3.0.1";

  pyproject = true;
  build-system = [ setuptools ];

  src = fetchFromGitHub {
    owner = "comet-ml";
    repo = "cometx";
    tag = version;
    hash = "sha256-Dudg1GLeo9WhtZnW+PEi10pxA+EDUBs2u3oIBMN8w30=";
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
  ];

  # WARNING: Running the tests will create experiments, models, assets, etc.
  # on your Comet account.
  doCheck = false;

  pythonImportsCheck = [ "cometx" ];

  meta = {
    description = "Open source extensions for the Comet SDK";
    homepage = "https://github.com/comet-ml/comet-sdk-extensions/";
    changelog = "https://github.com/comet-ml/cometx/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jherland ];
    mainProgram = "cometx";
  };
}
