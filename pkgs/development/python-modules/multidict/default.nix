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
  version = "6.6.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "multidict";
    tag = "v${version}";
    hash = "sha256-Ewxwz+0Y8pXJpHobLxrV7cuA9fsAaawWmW9XoEg7dxU=";
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

  env =
    { }
    // lib.optionalAttrs stdenv.cc.isClang {
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

  meta = with lib; {
    changelog = "https://github.com/aio-libs/multidict/blob/${src.tag}/CHANGES.rst";
    description = "Multidict implementation";
    homepage = "https://github.com/aio-libs/multidict/";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
