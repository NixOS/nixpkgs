{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "kgb";
  version = "7.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "beanbaginc";
    repo = "kgb";
    tag = "release-${version}";
    hash = "sha256-hNJXoUIyrCB9PCWLCmN81F6pBRwZApDR6JWA0adyklw=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "kgb" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Python function spy support for unit tests";
    homepage = "https://github.com/beanbaginc/kgb";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
