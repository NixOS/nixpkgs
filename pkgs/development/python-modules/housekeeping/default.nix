{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  typing-extensions,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "housekeeping";
  version = "1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "beanbaginc";
    repo = "housekeeping";
    tag = "release-${version}";
    hash = "sha256-hRWZSRoXscjkUm0NUpkM6pKEdoirN6ZmpjWlNgoyCVY=";
  };

  build-system = [ setuptools ];

  dependencies = [ typing-extensions ];

  pythonImportsCheck = [ "housekeeping" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Reusable deprecation helpers for Python projects";
    homepage = "https://github.com/beanbaginc/housekeeping";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
