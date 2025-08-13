{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  objgraph,
  pytestCheckHook,
  pytest-codspeed,
  pytest-cov-stub,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "multidict";
  version = "6.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "multidict";
    tag = "v${version}";
    hash = "sha256-crnWaThjymY0nbY4yvD+wX20vQcBkPrFAI+UkexNAbo=";
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

  nativeCheckInputs = [
    objgraph
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
