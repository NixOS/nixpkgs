{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  click,
  typing-extensions,
  setuptools,
  setuptools-git-versioning,
  pydantic,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "clickdc";
  version = "0.1.1-unstable-2026-07-18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kamilcuk";
    repo = "clickdc";
    rev = "83e79a4522b9070fd4bdad2f521f8f502380a7a9";
    hash = "sha256-JaBPwibuBacp1AXuYaZtyrsni9fTA+m7tRvQqeZ3ETw=";
  };

  build-system = [
    setuptools
    setuptools-git-versioning
  ];

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail 'setuptools-git-versioning<2' 'setuptools-git-versioning'
  '';

  dependencies = [
    click
    typing-extensions
  ];

  nativeCheckInputs = [
    pydantic
    pytestCheckHook
  ];

  pythonImportsCheck = [ "clickdc" ];

  meta = {
    description = "Define click command line options from a python dataclass";
    homepage = "https://github.com/Kamilcuk/clickdc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kyehn ];
  };
})
