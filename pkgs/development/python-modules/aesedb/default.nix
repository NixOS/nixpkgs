{
  lib,
  aiowinreg,
  buildPythonPackage,
  colorama,
  fetchFromGitHub,
  pycryptodomex,
  pythonOlder,
  setuptools,
  tqdm,
  unicrypto,
}:

buildPythonPackage rec {
  pname = "aesedb";
  version = "0.1.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "skelsec";
    repo = "aesedb";
    rev = "refs/tags/${version}";
    hash = "sha256-nYuMWE03Rsw1XuD/bxccpu8rddeXgS/EKJcO1VBLTLU=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    aiowinreg
    colorama
    pycryptodomex
    tqdm
    unicrypto
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "aesedb" ];

  meta = with lib; {
    description = "Parser for JET databases";
    mainProgram = "antdsparse";
    homepage = "https://github.com/skelsec/aesedb";
    changelog = "https://github.com/skelsec/aesedb/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
