{
  lib,
  buildPythonPackage,
  cbor2,
  fetchFromGitHub,
  pycryptodome,
  pythonOlder,
  setuptools,
  solc-select,
  toml,
}:

buildPythonPackage rec {
  pname = "crytic-compile";
  version = "0.3.8";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "crytic";
    repo = "crytic-compile";
    tag = version;
    hash = "sha256-7hmak2tqyhBxIv6zEySuxxCAQoeJJRsKMjb1t196s7w=";
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

  meta = with lib; {
    description = "Abstraction layer for smart contract build systems";
    mainProgram = "crytic-compile";
    homepage = "https://github.com/crytic/crytic-compile";
    changelog = "https://github.com/crytic/crytic-compile/releases/tag/${src.tag}";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [
      arturcygan
      hellwolf
    ];
  };
}
