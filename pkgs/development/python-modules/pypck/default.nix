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
  version = "0.7.13";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "alengwenus";
    repo = pname;
    rev = version;
    sha256 = "sha256-Gbz+3Hq4yStlTI7UxB4NBZigUzZjSJFFcwdzWtbGnio=";
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
