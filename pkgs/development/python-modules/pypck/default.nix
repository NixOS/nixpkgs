{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytest-timeout
, pytestCheckHook
, pythonOlder
, stdenv
}:

buildPythonPackage rec {
  pname = "pypck";
  version = "0.7.11";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "alengwenus";
    repo = pname;
    rev = version;
    sha256 = "1jj0y487qcxrprx4x2rs6r7rqsf5m9khk0xhigbvnbyvh8rsd2jr";
  };

  checkInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    "test_connection_lost"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "pypck" ];

  meta = with lib; {
    description = "LCN-PCK library written in Python";
    homepage = "https://github.com/alengwenus/pypck";
    license = with licenses; [ epl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
