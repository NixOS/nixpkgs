{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  more-itertools,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "patchpy";
  version = "2.0.4-unstable-2024-05-26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MatthewScholefield";
    repo = "patchpy";
    rev = "dcd673a0c2bf3f38e2b6b02e1a968be4f4d6c267";
    hash = "sha256-q5AaaNcf5HQ1OurzebuPiMTR44NMPxgSEiFzmcZqrFY=";
  };

  build-system = [ hatchling ];

  dependencies = [ more-itertools ];

  pythonImportsCheck = [ "patchpy" ];
  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Modern Python library for patch file parsing";
    homepage = "https://github.com/MatthewScholefield/patchpy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
