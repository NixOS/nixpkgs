{ buildPythonPackage, fetchPypi, lib, pytorch, contextlib2
, graphviz, networkx, six, opt-einsum, tqdm }:
buildPythonPackage rec {
  version = "1.1.0";
  pname = "pyro-ppl";

  src = fetchPypi {
    inherit version pname;
    sha256 = "5ca2fd19276fcfcf52babb48d22892a41d6238d7a6c65e63f704b070a3816479";
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
    broken = true;
  };
}
