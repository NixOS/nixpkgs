{ lib
, aiomisc
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "caio";
  version = "0.9.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-hUG5EaraoKj3D3K+Qm2Nm1AFe19qwRy/FnEb1SXWKDM=";
  };

  checkInputs = [
    aiomisc
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "caio"
  ];

  meta = with lib; {
    description = "File operations with asyncio support";
    homepage = "https://github.com/mosquito/caio";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
