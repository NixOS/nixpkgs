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
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "multidict";
  version = "6.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "multidict";
    tag = "v${version}";
    hash = "sha256-HOQRfSxf0+HeXsV4ShwfUDjNVyg2SjNuE157JLRlAL0=";
  };

  postPatch = ''
    # `python3 -I -c "import multidict"` fails with ModuleNotFoundError
    substituteInPlace tests/test_circular_imports.py \
      --replace-fail '"-I",' ""
  '';

  build-system = [ setuptools ];

  dependencies = lib.optionals (pythonOlder "3.11") [
    typing-extensions
  ];

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
    changelog = "https://github.com/aio-libs/multidict/blob/${src.tag}/CHANGES.rst";
    description = "Multidict implementation";
    homepage = "https://github.com/aio-libs/multidict/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
