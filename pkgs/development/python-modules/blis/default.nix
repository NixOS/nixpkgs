{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  cython,
  numpy,

  # tests
  hypothesis,
  pytestCheckHook,

  # passthru
  blis,
  numpy_1,
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "blis";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "cython-blis";
    tag = "release-v${version}";
    hash = "sha256-krUqAEPxJXdlolSbV5R0ZqrWaFuXh7IxSeFTsCr6iss=";
  };

  build-system = [
    setuptools
    cython
    numpy
  ];

  env =
    # Fallback to generic architectures when necessary:
    # https://github.com/explosion/cython-blis?tab=readme-ov-file#building-blis-for-alternative-architectures
    lib.optionalAttrs
      (
        # error: [Errno 2] No such file or directory: '/build/source/blis/_src/make/linux-cortexa57.jsonl'
        (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64)

        # clang: error: unknown argument '-mavx512pf'; did you mean '-mavx512f'?
        # Patching blis/_src/config/knl/make_defs.mk to remove the said flag does not work
        || (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64)
      )
      {
        BLIS_ARCH = "generic";
      };

  dependencies = [ numpy ];

  pythonImportsCheck = [ "blis" ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  # remove src module, so tests use the installed module instead
  preCheck = ''
    rm -rf ./blis
  '';

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

  meta = {
    changelog = "https://github.com/explosion/cython-blis/releases/tag/release-${version}";
    description = "BLAS-like linear algebra library";
    homepage = "https://github.com/explosion/cython-blis";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
