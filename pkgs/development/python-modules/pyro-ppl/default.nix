{ buildPythonPackage, fetchPypi, lib, pytorch, contextlib2
, graphviz, networkx, six, opt-einsum, tqdm, pyro-api }:

buildPythonPackage rec {
  version = "1.7.0";
  pname = "pyro-ppl";

  src = fetchPypi {
    inherit version pname;
    sha256 = "a8ec6968fdfa34f140584b266099238f1ffeacbbaab3775de5c94c0e685d018a";
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
