{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  makefun,
  multipledispatch,
  numpy,
  opt-einsum,
  typing-extensions,

  # checks
  pyro-ppl,
  torch,
  pandas,
  pillow,
  pyro-api,
  pytestCheckHook,
  pytest-xdist,
  requests,
  scipy,
  torchvision,

  stdenv,
}:

buildPythonPackage rec {
  pname = "funsor";
  version = "0.4.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pyro-ppl";
    repo = "funsor";
    rev = "refs/tags/${version}";
    hash = "sha256-Prj1saT0yoPAP8rDE0ipBEpR3QMk4PS12VSJlxc22p8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    makefun
    multipledispatch
    numpy
    opt-einsum
    typing-extensions
  ];

  nativeCheckInputs = [
    # Backend
    pyro-ppl
    torch

    pandas
    pillow
    pyro-api
    pytestCheckHook
    pytest-xdist
    requests
    scipy
    torchvision
  ];

  preCheck = ''
    export FUNSOR_BACKEND=torch
  '';

  pythonImportsCheck = [ "funsor" ];

  disabledTests =
    [
      # `test_torch_save` got broken by the update of torch (2.3.1 -> 2.4.0):
      # FutureWarning: You are using `torch.load` with `weights_only=False`...
      # TODO: Try to re-enable this test at next release
      "test_torch_save"
    ]
    ++ lib.optionals stdenv.isDarwin [
      # Failures related to JIT
      # RuntimeError: required keyword attribute 'Subgraph' has the wrong type
      "test_local_param_ok"
      "test_plate_ok"
    ];

  meta = {
    description = "Functional tensors for probabilistic programming";
    homepage = "https://funsor.pyro.ai";
    changelog = "https://github.com/pyro-ppl/funsor/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
