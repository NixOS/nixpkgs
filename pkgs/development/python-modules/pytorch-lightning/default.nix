{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, scikitlearn
, tqdm
, numpy
, pytorch
, torchvision
, pandas
, test-tube
, future
, coverage
, pytest
, mlflow
}:

buildPythonPackage rec {
  pname = "pytorch-lightning";
  version = "0.5.3.2";

  disabled = !isPy3k; # requires python version >=3.6

  src = fetchFromGitHub {
    owner = "williamFalcon";
    repo = pname;
    rev = version;
    sha256 = "0vws85dkw2df243fgsh7c8vz9l33a57gvf6lchzb0h2v16q4h2hm";
  };


  # comet_ml not currently available in nixpkgs
  # not required for pytorch-lightning
  patchPhase = ''
    substituteInPlace requirements.txt \
      --replace "tqdm==4.35.0" "tqdm" \
      --replace "numpy==1.16.4" "numpy" \
      --replace "scikit-learn==0.20.2" "scikit-learn" \
      --replace "torchvision>=0.3.0" "torchvision"
    substituteInPlace pytorch_lightning/logging/__init__.py \
      --replace "from .comet_logger import CometLogger" ""
    rm pytorch_lightning/logging/comet_logger.py
  '';
    
  propagatedBuildInputs = [
    scikitlearn
    tqdm
    numpy
    pytorch
    torchvision
    pandas
    test-tube
    future
  ];
  
  # lots of network access needed: https://gist.github.com/09b804918e5ca4b7dc55bb28ca4597f5
  doCheck = true;

  checkPhase = ''
    py.test pytorch_lightning tests pl_examples -v --doctest-modules -k not test_running_test_pretrained_model -k not test_cpu_restore_training
  '';

  
  checkInputs = [
    # mlflow
    coverage
    pytest
  ];

  meta = with lib; {
    description = "PyTorch Lightning is the lightweight PyTorch wrapper for ML researchers";
    homepage = https://github.com/williamFalcon/pytorch-lightning;
    license = licenses.asl20;
    maintainers = [ maintainers.tbenst ];
  };
}