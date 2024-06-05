{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  rye,
  hatchling,
  more-itertools,
  pretalx,
  pytestCheckHook
}:

buildPythonPackage {
  pname = "patchpy";
  version = "0-unstable-2024-05-26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MatthewScholefield";
    repo = "patchpy";
    rev = "dcd673a0c2bf3f38e2b6b02e1a968be4f4d6c267";
    hash = "sha256-q5AaaNcf5HQ1OurzebuPiMTR44NMPxgSEiFzmcZqrFY=";
  };

  build-system = [ setuptools rye hatchling ];

  dependencies = [ more-itertools pretalx ];

  pythonImportsCheck = [ "patchpy" ];
  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "A modern Python library for patch file parsing (diff file parsing)";
    homepage = "https://github.com/MatthewScholefield/patchpy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
