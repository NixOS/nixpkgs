{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  graphviz,
  ipywidgets,
  matplotlib,
  notebook,
  numpy,
  opt-einsum,
  pandas,
  pillow,
  pyro-api,
  scikit-learn,
  scipy,
  seaborn,
  setuptools,
  torch,
  torchvision,
  tqdm,
  wget,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyro-ppl";
  version = "1.9.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyro-ppl";
    repo = "pyro";
    tag = finalAttrs.version;
    hash = "sha256-P33neKtdBoIjKjv8KvoECOtlyaLEyb1spDwyGhPAVHk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    opt-einsum
    pyro-api
    torch
    tqdm
  ];

  optional-dependencies = {
    extras = [
      notebook
      ipywidgets
      graphviz
      matplotlib
      torchvision
      pandas
      pillow
      scikit-learn
      seaborn
      scipy
      wget
    ];
  };

  doCheck = false;

  pythonImportsCheck = [
    "pyro"
    "pyro.distributions"
    "pyro.infer"
    "pyro.optim"
  ];

  meta = {
    description = "Library for probabilistic modeling and inference";
    homepage = "http://pyro.ai";
    changelog = "https://github.com/pyro-ppl/pyro/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      teh
      georgewhewell
    ];
  };
})
