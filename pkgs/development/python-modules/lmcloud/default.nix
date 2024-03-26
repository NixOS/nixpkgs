{ lib
, authlib
, bleak
, buildPythonPackage
, fetchFromGitHub
, httpx
, pythonOlder
, setuptools
, websockets
}:

buildPythonPackage rec {
  pname = "lmcloud";
  version = "1.1.5";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "zweckj";
    repo = "lmcloud";
    rev = "refs/tags/v${version}";
    hash = "sha256-7w/7A66JDMu2Qn0V8GeUuBhDApTN/9SAriEUGJdKVEM=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    authlib
    bleak
    httpx
    websockets
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "lmcloud"
  ];

  meta = with lib; {
    description = "Library to interface with La Marzocco's cloud";
    homepage = "https://github.com/zweckj/lmcloud";
    changelog = "https://github.com/zweckj/lmcloud/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
