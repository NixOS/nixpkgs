{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  comet-ml,
  ipython,
  matplotlib,
  numpy,
  requests,
  scipy,
  selenium,
  urllib3,
  zipfile2,
}:

buildPythonPackage rec {
  pname = "cometx";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "comet-ml";
    repo = "cometx";
    tag = version;
    hash = "sha256-5lJDvzhXn2bQzMl6heukCB3ov1hQffS83+pthUm7YLQ=";
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
