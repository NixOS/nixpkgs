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
  version = "0.3.7";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "crytic";
    repo = "crytic-compile";
    rev = "refs/tags/${version}";
    hash = "sha256-SMkFzGZg/6akclQ0XLUvjK3uoypsHfRru+B4VurjOrM=";
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
    changelog = "https://github.com/crytic/crytic-compile/releases/tag/${version}";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [
      arturcygan
      hellwolf
    ];
  };
}
