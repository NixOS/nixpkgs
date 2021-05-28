{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, matplotlib
, mock
, pytorch
, pynvml
, scikitlearn
, tqdm
}:

buildPythonPackage rec {
  pname = "ignite";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = pname;
    rev = "v${version}";
    sha256 = "0i863kxi1r1hspj19lhn6r8256vdazjcyvis0s33fgzrf7kxi08x";
  };

  checkInputs = [ pytest matplotlib mock ];
  propagatedBuildInputs = [ pytorch scikitlearn tqdm pynvml ];

  # Some packages are not in NixPkgs; other tests try to build distributed
  # models, which doesn't work in the sandbox.
  checkPhase = ''
    pytest -k 'not visdom and not tensorboard and not mlflow and not polyaxon and not conftest and not engines and not distrib_' tests/
  '';

  meta = with lib; {
    description = "High-level training library for PyTorch";
    homepage = "https://pytorch.org/ignite";
    license = licenses.bsd3;
    maintainers = [ maintainers.bcdarwin ];
  };
}
