{
  lib,
  buildPythonPackage,
  pytestCheckHook,
  fetchFromGitHub,
  graphviz,
  ipywidgets,
  matplotlib,
  ninja,
  notebook,
  numpy,
  opt-einsum,
  pandas,
  pillow,
  pyro-api,
  scikit-learn,
  scipy,
  seaborn,
  setuptools,
  torch,
  torchvision,
  tqdm,
  wget,
  pytest-xdist,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyro-ppl";
  version = "1.9.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyro-ppl";
    repo = "pyro";
    tag = finalAttrs.version;
    hash = "sha256-P33neKtdBoIjKjv8KvoECOtlyaLEyb1spDwyGhPAVHk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    opt-einsum
    pyro-api
    torch
    tqdm
  ];

  optional-dependencies = {
    extras = [
      notebook
      ipywidgets
      graphviz
      matplotlib
      torchvision
      pandas
      pillow
      scikit-learn
      seaborn
      scipy
      wget
    ];
  };

  pythonImportsCheck = [
    "pyro"
    "pyro.distributions"
    "pyro.infer"
    "pyro.optim"
  ];

  preCheck =
    # Added for the tests/distributions/test_spanning_tree.py
    ''
      export TORCH_EXTENSIONS_DIR=$(mktemp -d)
    ''
    # Avoid a race between xdist workers when tests/perf/test_benchmark.py creates it at import
    + ''
      mkdir -p .benchmarks
    '';

  nativeCheckInputs = [
    graphviz
    ninja
    pytest-xdist
    pytestCheckHook
    scipy
  ];

  pytestFlags = [
    "--stage=unit"

    # FutureWarning: `torch.jit.{trace,trace_method,save,load}` is not supported in Python 3.14+
    # Upstream only ignores the "is deprecated" variant of these warnings.
    # Note: `-W` messages are matched literally as a prefix, not as regexes.
    "-Wignore:`torch.jit.:FutureWarning"
  ];

  disabledTests = [
    "test_stable_with_log_prob_param_fit"
  ];

  meta = {
    description = "Library for probabilistic modeling and inference";
    homepage = "http://pyro.ai";
    changelog = "https://github.com/pyro-ppl/pyro/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      Filippo-Galli
      georgewhewell
      teh
    ];
  };
})
