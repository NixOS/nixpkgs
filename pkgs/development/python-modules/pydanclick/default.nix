{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pydantic,
  pydantic-core,
  click,
  pytest7CheckHook,
  pydantic-settings,
}:

buildPythonPackage rec {
  pname = "pydanclick";
  version = "0.5.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "felix-martel";
    repo = "pydanclick";
    tag = "v${version}";
    hash = "sha256-Cgjq+9j6v7KILjfhK+4Y5joZPU2/ufJiIsdAfnSG9x4=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    pydantic
    pydantic-core
    click
  ];

  nativeCheckInputs = [
    # Still uses RaisesContext from pytest 7
    pytest7CheckHook
    pydantic-settings
  ];

  disabledTests = [
    # Seems to require typing-extensions
    "test_complex_types_example_help"
  ];

  pythonImportsCheck = [ "pydanclick" ];

  meta = {
    description = "Add click options from a Pydantic model";
    homepage = "https://github.com/felix-martel/pydanclick";
    changelog = "https://github.com/felix-martel/pydanclick/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.erictapen ];
  };
}
