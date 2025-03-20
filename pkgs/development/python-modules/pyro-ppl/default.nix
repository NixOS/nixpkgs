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
  pythonOlder,
  scikit-learn,
  scipy,
  seaborn,
  setuptools,
  torch,
  torchvision,
  tqdm,
  wget,
}:

buildPythonPackage rec {
  pname = "pyro-ppl";
  version = "1.9.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pyro-ppl";
    repo = "pyro";
    tag = version;
    hash = "sha256-Dvbl/80EGoGWGhWYVIf/xjovUJG1+3WtpMH+lx1oB2E=";
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
      # visdom
      wget
    ];
  };

  # pyro not shipping tests do simple smoke test instead
  doCheck = false;

  pythonImportsCheck = [
    "pyro"
    "pyro.distributions"
    "pyro.infer"
    "pyro.optim"
  ];

  meta = with lib; {
    description = "Library for probabilistic modeling and inference";
    homepage = "http://pyro.ai";
    changelog = "https://github.com/pyro-ppl/pyro/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      teh
      georgewhewell
    ];
  };
}
