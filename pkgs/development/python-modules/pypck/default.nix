{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytest-cov
, pytest-timeout
, pytestCheckHook
, pythonOlder
, stdenv
}:

buildPythonPackage rec {
  pname = "pypck";
  version = "0.7.9";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "alengwenus";
    repo = pname;
    rev = version;
    sha256 = "0clpi6bplzw7qg2m0hgwqr71zwxrh901gwprhd1yjykn30njp5bw";
  };

  checkInputs = [
    pytest-asyncio
    pytest-cov
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
