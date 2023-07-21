{ lib
, buildPythonPackage
, fetchFromGitHub
, pydantic_1
, pytestCheckHook
, pythonOlder
, srsly
}:

buildPythonPackage rec {
  pname = "confection";
  version = "0.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "explosion";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-yF+rG0UblGk6BCrqFrWXkB8ET0NPCL7v+4IJTmkYoTY=";
  };

  propagatedBuildInputs = [
    pydantic_1
    srsly
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "confection"
  ];

  meta = with lib; {
    description = "Library that offers a configuration system";
    homepage = "https://github.com/explosion/confection";
    changelog  = "https://github.com/explosion/confection/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
