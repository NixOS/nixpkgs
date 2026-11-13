{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  prompt-toolkit,
  pygments,
}:

buildPythonPackage {
  pname = "pypager";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "prompt-toolkit";
    repo = "pypager";
    rev = "0255d59a14ffba81c3842ef570c96c8dfee91e8e";
    hash = "sha256-uPpVAI12INKFZDiTQdzQ0dhWCBAGeu0488zZDEV22mU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    prompt-toolkit
    pygments
  ];

  pythonImportsCheck = [ "pypager" ];

  # no tests
  doCheck = false;

  meta = {
    description = ''Pure Python pager (like "more" and "less")'';
    homepage = "https://github.com/prompt-toolkit/pypager";
    license = lib.licenses.bsd3;
    mainProgram = "pypager";
    maintainers = with lib.maintainers; [ taha-yassine ];
  };
}
