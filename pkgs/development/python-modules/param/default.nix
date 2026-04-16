{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  hatch-vcs,

  # tests
  numpy,
  pandas,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "param";
  version = "2.4.0a1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "holoviz";
    repo = "param";
    tag = "v${version}";
    hash = "sha256-0f1qGJa5XHoqWN86Q310DXTOwi9/jXxCyktKz235nno=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  nativeCheckInputs = [
    numpy
    pandas
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlags = [
    "-Wignore::DeprecationWarning"
  ];

  pythonImportsCheck = [ "param" ];

  meta = {
    description = "Declarative Python programming using Parameters";
    homepage = "https://param.holoviz.org/";
    changelog = "https://github.com/holoviz/param/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
