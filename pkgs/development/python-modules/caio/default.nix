{ lib
, aiomisc
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "caio";
  version = "0.9.11";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-BFlpjbC2yxwGtCAMfn1VM5zmioyN5fFNMJDDWceB+LE=";
  };

  nativeCheckInputs = [
    aiomisc
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "caio"
  ];

  meta = with lib; {
    description = "File operations with asyncio support";
    homepage = "https://github.com/mosquito/caio";
    changelog = "https://github.com/mosquito/caio/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
