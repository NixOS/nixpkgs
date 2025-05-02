{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytest-timeout
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "pypck";
  version = "0.7.19";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "alengwenus";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-D4uUR8A1mrT+mxUswS34hSRczjRkRro/pz9NbMUCPjM=";
  };

  postPatch = ''
    echo "${version}" > VERSION
  '';

  nativeBuildInputs = [
    setuptools
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
