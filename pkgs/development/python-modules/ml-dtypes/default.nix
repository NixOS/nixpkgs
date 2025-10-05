{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  numpy,

  # tests
  absl-py,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ml-dtypes";
  version = "0.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jax-ml";
    repo = "ml_dtypes";
    tag = "v${version}";
    hash = "sha256-y0w+8h6KMYf6ZvlP3rEVt1I11jkbNNuJDIvfNFFaBQE=";
    # Since this upstream patch (https://github.com/jax-ml/ml_dtypes/commit/1bfd097e794413b0d465fa34f2eff0f3828ff521),
    # the attempts to use the nixpkgs packaged eigen dependency have failed.
    # Hence, we rely on the bundled eigen library.
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools~=80.8.0" "setuptools"
  '';

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  nativeCheckInputs = [
    absl-py
    pytestCheckHook
  ];

  preCheck = ''
    # remove src module, so tests use the installed module instead
    mv ./ml_dtypes/tests ./tests
    rm -rf ./ml_dtypes
  '';

  pythonImportsCheck = [ "ml_dtypes" ];

  meta = {
    description = "Stand-alone implementation of several NumPy dtype extensions used in machine learning libraries";
    homepage = "https://github.com/jax-ml/ml_dtypes";
    changelog = "https://github.com/jax-ml/ml_dtypes/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      GaetanLepage
      samuela
    ];
  };
}
