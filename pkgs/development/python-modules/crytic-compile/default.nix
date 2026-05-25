{
  lib,
  buildPythonPackage,
  cbor2,
  fetchFromGitHub,
  pycryptodome,
  setuptools,
  solc-select,
  toml,
}:

buildPythonPackage rec {
  pname = "crytic-compile";
  version = "0.3.11";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "crytic";
    repo = "crytic-compile";
    tag = version;
    hash = "sha256-NVAIVUfh1bizg/HG1z7Ze6o5w6wto744Ogq0LPg0gXg=";
  };

  propagatedBuildInputs = [
    cbor2
    pycryptodome
    setuptools
    solc-select
    toml
  ];

  # Test require network access
  doCheck = false;

  # required for import check to work
  # PermissionError: [Errno 13] Permission denied: '/homeless-shelter'
  env.HOME = "/tmp";
  pythonImportsCheck = [ "crytic_compile" ];

  meta = {
    description = "Abstraction layer for smart contract build systems";
    mainProgram = "crytic-compile";
    homepage = "https://github.com/crytic/crytic-compile";
    changelog = "https://github.com/crytic/crytic-compile/releases/tag/${src.tag}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      arturcygan
      hellwolf
    ];
  };
}
