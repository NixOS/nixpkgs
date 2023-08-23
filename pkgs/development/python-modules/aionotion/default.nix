{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, poetry-core
, pydantic
, pytest-aiohttp
, pytest-asyncio
, pytest-cov
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aionotion";
  version = "2023.05.5";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    hash = "sha256-/2sF8m5R8YXkP89bi5zR3h13r5LrFOl1OsixAcX0D4o=";
  };

  patches = [
    # This patch removes references to setuptools and wheel that are no longer
    # necessary and changes poetry to poetry-core, so that we don't need to add
    # unnecessary nativeBuildInputs.
    #
    #   https://github.com/bachya/aionotion/pull/269
    #
    (fetchpatch {
      name = "clean-up-build-dependencies.patch";
      url = "https://github.com/bachya/aionotion/commit/53c7285110d12810f9b43284295f71d052a81b83.patch";
      hash = "sha256-RLRbHmaR2A8MNc96WHx0L8ccyygoBUaOulAuRJkFuUM=";
    })
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    pydantic
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    aresponses
    pytest-aiohttp
    pytest-asyncio
    pytest-cov
    pytestCheckHook
  ];

  disabledTestPaths = [
    "examples"
  ];

  pythonImportsCheck = [
    "aionotion"
  ];

  meta = with lib; {
    description = "Python library for Notion Home Monitoring";
    homepage = "https://github.com/bachya/aionotion";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
