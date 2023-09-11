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
  pname = "aiowatttime";
  version = "2023.08.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-/ulDImbLOTcoA4iH8e65A01aqqnCLn+01DWuM/4H4p4=";
  };

  patches = [
    # This patch removes references to setuptools and wheel that are no longer
    # necessary and changes poetry to poetry-core, so that we don't need to add
    # unnecessary nativeBuildInputs.
    #
    #   https://github.com/bachya/aiowatttime/pull/206
    #
    (fetchpatch {
      name = "clean-up-build-dependencies.patch";
      url = "https://github.com/bachya/aiowatttime/commit/c3cd53f794964c5435148caacd04f4e0ab8f550a.patch";
      hash = "sha256-RLRbHmaR2A8MNc96WHx0L8ccyygoBUaOulAuRJkFuUM=";
    })
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    aresponses
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  # Ignore the examples directory as the files are prefixed with test_
  disabledTestPaths = [ "examples/" ];

  pythonImportsCheck = [ "aiowatttime" ];

  meta = with lib; {
    description = "Python library for interacting with WattTime";
    homepage = "https://github.com/bachya/aiowatttime";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
