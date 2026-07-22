{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  fastcore,
  numpy,
  fasthtml,
  ipython,
}:

buildPythonPackage (finalAttrs: {
  pname = "fastprogress";
  version = "1.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fastai";
    repo = "fastprogress";
    tag = finalAttrs.version;
    hash = "sha256-KQ8CYS+SSTve905k695w3TjCFBdWxGR3PqDsYTV8b4k=";
  };

  build-system = [ setuptools ];

  dependencies = [
    fastcore
    numpy
    fasthtml
    ipython
  ];

  # no real tests
  doCheck = false;
  pythonImportsCheck = [ "fastprogress" ];

  meta = {
    homepage = "https://github.com/fastai/fastprogress";
    changelog = "https://github.com/AnswerDotAI/fastprogress/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Simple and flexible progress bar for Jupyter Notebook and console";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ris ];
  };
})
