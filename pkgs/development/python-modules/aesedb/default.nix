{ lib
, aiowinreg
, buildPythonPackage
, colorama
, fetchFromGitHub
, pycryptodomex
, pythonOlder
, setuptools
, tqdm
, unicrypto
}:

buildPythonPackage rec {
  pname = "aesedb";
  version = "0.1.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "skelsec";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-TXGRXo3754dEgRotDO5vSl9vj119Xday/176yem3cqk=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiowinreg
    colorama
    pycryptodomex
    tqdm
    unicrypto
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "aesedb"
  ];

  meta = with lib; {
    description = "Parser for JET databases";
    homepage = "https://github.com/skelsec/aesedb";
    changelog = "https://github.com/skelsec/aesedb/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
