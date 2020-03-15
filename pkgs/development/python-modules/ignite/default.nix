{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, mock
, pytorch
, pynvml
, scikitlearn
, tqdm
}:

buildPythonPackage rec {
  pname = "ignite";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = pname;
    rev = "v${version}";
    sha256 = "15k6dd11yxn4923llcpmw4srl1by5ljhh7aw5pnkn4n4qpywh6cm";
  };

  checkInputs = [ pytest mock ];

  checkPhase = ''
    pytest -k 'not visdom and not tensorboard and not mlflow and not polyaxon' tests/
  '';
  # these packages are not currently in nixpkgs

  propagatedBuildInputs = [ pytorch scikitlearn tqdm pynvml ];

  meta = with lib; {
    description = "High-level training library for PyTorch";
    homepage = https://pytorch.org/ignite;
    license = licenses.bsd3;
    maintainers = [ maintainers.bcdarwin ];
  };
}
