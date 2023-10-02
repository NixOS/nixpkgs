{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, poetry-core
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytile";
  version = "2023.08.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-wPtGofli3ZKBcAwjwjCbeYnLaSZ5lLshlBSz1/WlAcg=";
  };

  patches = [
    # This patch removes references to setuptools and wheel that are no longer
    # necessary and changes poetry to poetry-core, so that we don't need to add
    # unnecessary nativeBuildInputs.
    #
    #   https://github.com/bachya/pytile/pull/286
    #
    (fetchpatch {
      name = "clean-up-build-dependencies.patch";
      url = "https://github.com/bachya/pytile/commit/bdb5d96ba9d640bf85a1ae9c3787704dbc2ced23.patch";
      hash = "sha256-RLRbHmaR2A8MNc96WHx0L8ccyygoBUaOulAuRJkFuUM=";
    })
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  nativeCheckInputs = [
    aresponses
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Ignore the examples as they are prefixed with test_
    "examples/"
  ];

  pythonImportsCheck = [
    "pytile"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = " Python API for Tile Bluetooth trackers";
    longDescription = ''
      pytile is a simple Python library for retrieving information on Tile
      Bluetooth trackers (including last location and more).
    '';
    homepage = "https://github.com/bachya/pytile";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
