{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "mmcif-pdbx";
  version = "2.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "Electrostatics";
    repo = "mmcif_pdbx";
    rev = "refs/tags/v${version}";
    hash = "sha256-ymMQ/q4IMoq+B8RvIdL0aqolKxyE/4rnVfd4bUV5OUY=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pdbx"
  ];

  meta = with lib; {
    description = "Yet another version of PDBx/mmCIF Python implementation";
    homepage = "https://github.com/Electrostatics/mmcif_pdbx";
    changelog = "https://github.com/Electrostatics/mmcif_pdbx/releases/tag/v${version}";
    license = licenses.cc0;
    maintainers = with maintainers; [ natsukium ];
  };
}
