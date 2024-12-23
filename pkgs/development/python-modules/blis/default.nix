{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cython,
  hypothesis,
  numpy,
  pytestCheckHook,
  pythonOlder,
  blis,
  numpy_1,
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "blis";
  version = "1.0.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "cython-blis";
    rev = "refs/tags/release-v${version}";
    hash = "sha256-J/EaJNmImcK4zScpbYPlQuoLyjoUkUgxUp6926P6rUQ=";
  };

  postPatch = ''
    # See https://github.com/numpy/numpy/issues/21079
    # has no functional difference as the name is only used in log output
    substituteInPlace blis/benchmark.py \
      --replace-fail 'numpy.__config__.blas_ilp64_opt_info["libraries"]' '["dummy"]'
  '';

  preCheck = ''
    # remove src module, so tests use the installed module instead
    rm -rf ./blis
  '';

  build-system = [
    setuptools
    cython
    numpy
  ];

  dependencies = [ numpy ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "blis" ];

  passthru = {
    tests = {
      numpy_1 = blis.overridePythonAttrs (old: {
        numpy = numpy_1;
      });
    };
    updateScript = gitUpdater {
      rev-prefix = "release-v";
    };
  };

  meta = with lib; {
    changelog = "https://github.com/explosion/cython-blis/releases/tag/release-v${version}";
    description = "BLAS-like linear algebra library";
    homepage = "https://github.com/explosion/cython-blis";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nickcao ];
  };
}
