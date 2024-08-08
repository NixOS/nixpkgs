{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cython,
  hypothesis,
  numpy_2,
  pytestCheckHook,
  pythonOlder,
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "blis";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "cython-blis";
    rev = "refs/tags/release-v${version}";
    hash = "sha256-XS6h2c+8BJ9pAvIX8340C4vRZEBRmEZc6/6tH7ooqNU=";
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
  ];

  dependencies = [ numpy_2 ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "blis" ];

  passthru = {
    # Do not update to BLIS 0.9.x until the following issue is resolved:
    # https://github.com/explosion/thinc/issues/771#issuecomment-1255825935
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      rev-prefix = "v";
      ignoredVersions = "0\.9\..*";
    };
  };

  meta = with lib; {
    description = "BLAS-like linear algebra library";
    homepage = "https://github.com/explosion/cython-blis";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nickcao ];
  };
}
