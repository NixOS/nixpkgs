{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  graphviz,
  jupyter,
  matplotlib,
  networkx,
  opt-einsum,
  pandas,
  pillow,
  pyro-api,
  pythonOlder,
  torch,
  scikit-learn,
  seaborn,
  setuptools,
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
    rev = "refs/tags/${version}";
    hash = "sha256-Dvbl/80EGoGWGhWYVIf/xjovUJG1+3WtpMH+lx1oB2E=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    pyro-api
    torch
    networkx
    opt-einsum
    tqdm
  ];

  passthru.optional-dependencies = {
    extras = [
      graphviz
      jupyter
      # lap
      matplotlib
      pandas
      pillow
      scikit-learn
      seaborn
      torchvision
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
