{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  nix-update-script,
}:
buildPythonPackage rec {
  pname = "maseya-z3pr";
  version = "1.0.0.rc1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Maseya";
    repo = "z3pr-py";
    rev = "v${version}";
    hash = "sha256-T/UN/AkVbvIDBynzUcwPzKB/PfvfI3IrGWxppFcfjD4=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests/*_test.py" ];

  pythonImportsCheck = [ "maseya.z3pr" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Zelda 3 Palette Randomizer";
    homepage = "https://github.com/Maseya/z3pr-py";
    changelog = "https://github.com/Maseya/z3pr-py/blob/master/CHANGELOG.md";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
