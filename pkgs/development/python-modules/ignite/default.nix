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
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = pname;
    rev = "v${version}";
    sha256 = "00vcmhnp14s54g386izgaxzrdr2nqv3pz9nvpyiwrn33zawr308z";
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
