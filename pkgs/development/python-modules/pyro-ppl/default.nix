{ buildPythonPackage, fetchPypi, lib, pytorch, contextlib2
, graphviz, networkx, six, opt-einsum, tqdm, pyro-api }:

buildPythonPackage rec {
  version = "1.8.1";
  pname = "pyro-ppl";

  src = fetchPypi {
    inherit version pname;
    sha256 = "sha256-18BJ6y50haYStN2ZwkwwnMhgx8vGsZczhwNPVDbRyNY=";
  };

  propagatedBuildInputs = [
    pyro-api
    pytorch
    contextlib2
    # TODO(tom): graphviz pulls in a lot of dependencies - make
    # optional when some time to figure out how.
    graphviz
    networkx
    six
    opt-einsum
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

  meta = {
    description = "A Python library for probabilistic modeling and inference";
    homepage = "http://pyro.ai";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ teh georgewhewell ];
  };
}
