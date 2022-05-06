{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytest-timeout
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pypck";
  version = "0.7.14";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "alengwenus";
    repo = pname;
    rev = version;
    sha256 = "sha256-v8eCCbSnAmJUmHSNS+lz8JRhDFrqyxgAkgcZ2bzfOTg=";
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

  pythonImportsCheck = [
    "pypck"
  ];

  meta = with lib; {
    description = "LCN-PCK library written in Python";
    homepage = "https://github.com/alengwenus/pypck";
    license = with licenses; [ epl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
