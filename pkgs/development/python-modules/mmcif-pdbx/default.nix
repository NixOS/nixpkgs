{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mmcif-pdbx";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Electrostatics";
    repo = "mmcif_pdbx";
    tag = "v${version}";
    hash = "sha256-HzRJ8bzUHAmF7WA20DefvgSNDxMaqJCxfgqTHrS0BqU=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pdbx" ];

  meta = {
    description = "Yet another version of PDBx/mmCIF Python implementation";
    homepage = "https://github.com/Electrostatics/mmcif_pdbx";
    changelog = "https://github.com/Electrostatics/mmcif_pdbx/releases/tag/v${version}";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
