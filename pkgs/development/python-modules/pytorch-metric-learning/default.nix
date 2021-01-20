{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, numpy
, scikitlearn
, pytestCheckHook
, pytorch
, torchvision
, tqdm
}:

buildPythonPackage rec {
  pname   = "pytorch-metric-learning";
  version = "0.9.95";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "KevinMusgrave";
    repo = pname;
    rev = "v${version}";
    sha256 = "1msvs1j3n47762ahm21bnkk2qqabxw8diiyi7s420x4zg24mr23g";
  };

  propagatedBuildInputs = [
    numpy
    pytorch
    scikitlearn
    torchvision
    tqdm
  ];

  preCheck = ''
    export HOME=$TMP
    export TEST_DEVICE=cpu
    export TEST_DTYPES=float32,float64  # half-precision tests fail on CPU
  '';
  # package only requires `unittest`, but use `pytest` to exclude tests
  checkInputs = [ pytestCheckHook ];
  disabledTests = [
    # requires FAISS (not in Nixpkgs)
    "test_accuracy_calculator_and_faiss"
    # require network access:
    "test_get_nearest_neighbors"
    "test_tuplestoweights_sampler"
    "test_untrained_indexer"
  ];

  meta = {
    description = "Metric learning library for PyTorch";
    homepage = "https://github.com/KevinMusgrave/pytorch-metric-learning";
    changelog = "https://github.com/KevinMusgrave/pytorch-metric-learning/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
