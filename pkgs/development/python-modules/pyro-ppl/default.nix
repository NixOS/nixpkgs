{ lib
, buildPythonPackage
, contextlib2
, fetchPypi
, graphviv
, matplotlib
, networkx
, numpy
, opt-einsum
, pyro-api
, pythonOlder
, pytorch
, tqdm
}:

buildPythonPackage rec {
  pname = "pyro-ppl";
  version = "1.8.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-18BJ6y50haYStN2ZwkwwnMhgx8vGsZczhwNPVDbRyNY=";
  };

  propagatedBuildInputs = [
    contextlib2
    graphviv
    matplotlib
    networkx
    numpy
    opt-einsum
    pyro-api
    pytorch
    tqdm
  ];

  # pyro not shipping tests do simple smoke test instead
  pythonImportsCheck = [
    "pyro"
    "pyro.distributions"
    "pyro.infer"
    "pyro.optim"
  ];

  doCheck = false;

  meta = with lib; {
    description = "A Python library for probabilistic modeling and inference";
    homepage = "http://pyro.ai";
    license = licenses.mit;
    maintainers = with maintainers; [ teh georgewhewell ];
  };
}
