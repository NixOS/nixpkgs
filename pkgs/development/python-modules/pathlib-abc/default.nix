{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pathlib-abc";
  version = "0.5.0";
  pyproject = true;

  src = fetchPypi {
    pname = "pathlib_abc";
    inherit version;
    hash = "sha256-RpyeVALG0wB9EcQGLrZlEwCkJdZwyRO0vEvXgZnOwsM=";
  };

  build-system = [ hatchling ];

  pythonImportsCheck = [ "pathlib_abc" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Python base classes for rich path objects";
    homepage = "https://github.com/barneygale/pathlib-abc";
    changelog = "https://github.com/barneygale/pathlib-abc/blob/${version}/CHANGES.rst";
    license = licenses.psfl;
    maintainers = [ ];
  };
}
