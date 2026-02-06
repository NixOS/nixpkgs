{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "result";
  version = "0.17.0";
  pyproject = true;

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

  meta = {
    description = "Rust-like result type for Python";
    homepage = "https://github.com/rustedpy/result";
    changelog = "https://github.com/rustedpy/result/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ emattiza ];
  };
}
