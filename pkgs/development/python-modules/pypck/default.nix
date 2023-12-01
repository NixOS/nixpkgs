{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pytest-asyncio
, pytest-timeout
, pytestCheckHook
, pythonOlder
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "pypck";
  version = "0.7.17";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "alengwenus";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-Vlt4+fRULb9mB0ceRmc7MJ50DnF9DAJPHA8iCbNVvcE=";
  };

  patches = [
    # https://github.com/alengwenus/pypck/pull/109
    (fetchpatch {
      name = "relax-setuptools-dependency.patch";
      url = "https://github.com/alengwenus/pypck/commit/17023ebe8082120b1eec086842ca809ec6e9df2b.patch";
      hash = "sha256-kTu1+IwDrcdqelyK/vfhxw8MQBis5I1jag7YTytKQhs=";
    })
  ];

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  nativeCheckInputs = [
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
