{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pathlib-abc";
  version = "0.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "barneygale";
    repo = "pathlib-abc";
    tag = version;
    hash = "sha256-Amr5yrdmS0jx1dnakstgE7JFs4QzNK150aG51GUrc2Y=";
  };

  build-system = [ hatchling ];

  pythonImportsCheck = [ "pathlib_abc" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Python base classes for rich path objects";
    homepage = "https://github.com/barneygale/pathlib-abc";
    changelog = "https://github.com/barneygale/pathlib-abc/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.psfl;
    maintainers = [ ];
  };
}
