{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  colorama,
  pytest,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pytest-resource-path";
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yukihiko-shinoda";
    repo = "pytest-resource-path";
    tag = "v${version}";
    hash = "sha256-f0jN6V6tQRbr/DHOKKTrFCb1EBUUxZAQRckMy2iiVqI=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  dependencies = [ colorama ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_resource_path" ];

  meta = {
    description = "Pytest plugin to provide path for uniform access to test resources";
    homepage = "https://github.com/yukihiko-shinoda/pytest-resource-path";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
