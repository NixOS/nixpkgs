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
  version = "0.7.16";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "alengwenus";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-OcXMVgG62JUH28BGvfO/rpnC++/klhBLJ2HafDu9R40=";
  };

  checkInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--asyncio-mode=auto"
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
    changelog = "https://github.com/alengwenus/pypck/releases/tag/${version}";
    license = with licenses; [ epl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
