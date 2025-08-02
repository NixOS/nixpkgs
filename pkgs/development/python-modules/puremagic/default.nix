{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "puremagic";
  version = "1.28";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cdgriffith";
    repo = "puremagic";
    tag = version;
    hash = "sha256-a7jRQUSbH3E6eJiXNKr4ikdSXRZ6+/csl/EMiKXMzmk=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "puremagic" ];

  meta = {
    description = "Implementation of magic file detection";
    homepage = "https://github.com/cdgriffith/puremagic";
    changelog = "https://github.com/cdgriffith/puremagic/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ globin ];
  };
}
