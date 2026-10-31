{
  stdenv,
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  objgraph,
  psutil,
  pytestCheckHook,
  pytest-codspeed,
  pytest-cov-stub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "multidict";
  version = "7.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "multidict";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qxBtZg04UED64H5QRBb1Hw5O3pY4I/Jy/N7HamgwKzM=";
  };

  postPatch = ''
    # `python3 -I -c "import multidict"` fails with ModuleNotFoundError
    substituteInPlace tests/test_circular_imports.py \
      --replace-fail '"-I",' ""

    substituteInPlace tests/test_leaks.py \
      --replace-fail '"-m", "coverage", "run", ' ""
  '';

  build-system = [ setuptools ];

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-Wno-error=unused-command-line-argument";
  };

  nativeCheckInputs = [
    objgraph
    psutil
    pytestCheckHook
    pytest-codspeed
    pytest-cov-stub
  ];

  preCheck = ''
    # import from $out
    rm -r multidict
  '';

  pythonImportsCheck = [ "multidict" ];

  meta = {
    changelog = "https://github.com/aio-libs/multidict/blob/${finalAttrs.src.tag}/CHANGES.rst";
    description = "Multidict implementation";
    homepage = "https://github.com/aio-libs/multidict/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
