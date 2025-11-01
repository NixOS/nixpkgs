{
  lib,
  aiowinreg,
  buildPythonPackage,
  colorama,
  fetchFromGitHub,
  pycryptodomex,
  setuptools,
  tqdm,
  unicrypto,
}:

buildPythonPackage rec {
  pname = "aesedb";
  version = "0.1.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "skelsec";
    repo = "aesedb";
    tag = version;
    hash = "sha256-jT5Aru/BqvJf4HpD418+GrkZ0/g2XcTV3oWSOmo0Sbw=";
  };

  build-system = [ setuptools ];

  dependencies = [
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
    homepage = "https://github.com/skelsec/aesedb";
    changelog = "https://github.com/skelsec/aesedb/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "antdsparse";
  };
}
