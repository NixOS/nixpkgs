{ buildPythonPackage, fetchPypi, lib, pytorch, contextlib2
, graphviz, networkx, six, opt-einsum, tqdm }:
buildPythonPackage rec {
  version = "0.3.2";
  pname = "pyro-ppl";

  src = fetchPypi {
    inherit version pname;
    sha256 = "f00db7e7747e016479ef65e3f00115d66a4200e59914f016d50e4d3e32bc94b0";
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
