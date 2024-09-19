{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "multidict";
  version = "6.1.0";

  disabled = pythonOlder "3.8";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "multidict";
    rev = "refs/tags/v${version}";
    hash = "sha256-rvL1XzMNBVBlElE5wznecL3Ku9h4tG9VeqGRd04iPXw=";
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
    pytest-cov-stub
    pytestCheckHook
  ];

  preCheck = ''
    # import from $out
    rm -r multidict
  '';

  pythonImportsCheck = [ "multidict" ];

  meta = with lib; {
    changelog = "https://github.com/aio-libs/multidict/blob/v${version}/CHANGES.rst";
    description = "Multidict implementation";
    homepage = "https://github.com/aio-libs/multidict/";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
