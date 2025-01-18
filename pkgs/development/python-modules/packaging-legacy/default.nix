{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  packaging,
  pretend,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "packaging-legacy";
  version = "23.0.post0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "di";
    repo = "packaging_legacy";
    tag = version;
    hash = "sha256-2TnJjxasC8+c+qHY60e6Jyqhf1nQJfj/tmIA/LvUsT8=";
  };

  build-system = [ setuptools ];

  dependencies = [ packaging ];

  nativeCheckInputs = [
    pretend
    pytestCheckHook
  ];

  pythonImportsCheck = [ "packaging_legacy" ];

  meta = with lib; {
    description = "Module to support for legacy Python Packaging functionality";
    homepage = "https://github.com/di/packaging_legacy";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
  };
}
