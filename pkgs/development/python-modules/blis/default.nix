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
  numpy_2,
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "blis";
  version = "1.0.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "cython-blis";
    rev = "refs/tags/release-v${version}";
    hash = "sha256-8JaQgTda1EBiZdSrZtKwJ8e/aDENQ+dMmTiH/t1ax5I=";
  };

  postPatch = ''
    # The commit pinning numpy to version 2 doesn't have any functional changes:
    # https://github.com/explosion/cython-blis/pull/108
    # BLIS should thus work with numpy and numpy_2.
    substituteInPlace pyproject.toml setup.py \
      --replace-fail "numpy>=2.0.0,<3.0.0" numpy

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
      numpy_2 = blis.overridePythonAttrs (old: {
        numpy = numpy_2;
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
