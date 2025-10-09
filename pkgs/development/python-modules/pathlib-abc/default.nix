{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pathlib-abc";
  version = "0.5.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "pathlib_abc";
    inherit version;
    hash = "sha256-vsmplUco6iEJL4oRaLWc1vOAoMNQPkZuDCrJx8JiNWQ=";
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
