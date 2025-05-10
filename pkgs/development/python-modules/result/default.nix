{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "result";
  version = "0.17.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "rustedpy";
    repo = "result";
    rev = "v${version}";
    hash = "sha256-o+7qKxGQCeMUnsmEReggvf+XwQWFHRCYArYk3DxCa50=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "result" ];

  meta = with lib; {
    description = "A Rust-like result type for Python";
    homepage = "https://github.com/rustedpy/result";
    changelog = "https://github.com/rustedpy/result/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ emattiza ];
  };
}
