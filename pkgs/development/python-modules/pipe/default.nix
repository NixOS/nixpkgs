{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pipe";
  version = "2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JulienPalard";
    repo = "Pipe";
    tag = "v${version}";
    hash = "sha256-/xMhh70g2KPOOivTjpAuyfu+Z44tBE5zAwpSIEKhK6M=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pipe" ];

  disabledTests = [
    # Test require network access
    "test_netcat"
  ];

  meta = {
    description = "Module to use infix notation";
    homepage = "https://github.com/JulienPalard/Pipe";
    changelog = "https://github.com/JulienPalard/Pipe/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
