{ buildPythonPackage, fetchPypi, lib, pytorch, contextlib2
, graphviz, networkx, six, opt-einsum, tqdm }:
buildPythonPackage rec {
  version = "0.3.1";
  pname = "pyro-ppl";

  src = fetchPypi {
    inherit version pname;
    sha256 = "2f684bdd7661d78db89297289334d801c76f2fbf1a551edb14e4d33b29985f3e";
  };

  propagatedBuildInputs = [
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
  checkPhase = ''
    python -c "import pyro"
    python -c "import pyro.distributions"
    python -c "import pyro.infer"
    python -c "import pyro.optim"
  '';

  meta = {
    description = "A Python library for probabilistic modeling and inference";
    homepage = http://pyro.ai;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ teh ];
  };
}
