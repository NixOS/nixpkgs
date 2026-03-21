{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mmcif-pdbx";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Electrostatics";
    repo = "mmcif_pdbx";
    tag = "v${version}";
    hash = "sha256-ymMQ/q4IMoq+B8RvIdL0aqolKxyE/4rnVfd4bUV5OUY=";
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
