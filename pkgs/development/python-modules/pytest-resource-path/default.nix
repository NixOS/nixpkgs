{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  colorama,
  pytest,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pytest-resource-path";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yukihiko-shinoda";
    repo = "pytest-resource-path";
    tag = "v${version}";
    hash = "sha256-9OBO9b02RrXilXUucerQQMTaQIRXtbcKCHqwwp9tBto=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "pytest-runner" ""
  '';

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  dependencies = [ colorama ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_resource_path" ];

  meta = with lib; {
    description = "Pytest plugin to provide path for uniform access to test resources";
    homepage = "https://github.com/yukihiko-shinoda/pytest-resource-path";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
