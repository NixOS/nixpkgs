{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, setuptools-scm
, aiohttp
, pytest
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-aiohttp";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DI/rSNyOuAhw4rFTrK9iu7zCB5d+vLdDZf/P4WrcnxU=";
  };

  patches = [
    # https://github.com/aio-libs/pytest-aiohttp/pull/26
    (fetchpatch {
      name = "fix-tests-with-pytest-asyncio-0.18.0.patch";
      url = "https://github.com/aio-libs/pytest-aiohttp/commit/97152c2dfdd368f799ec6bcb5fc315736a726f53.patch";
      hash = "sha256-g7MTyCKUHnufOfrbhVV58WtfbGt1uXx8F7U9U+EaXfg=";
    })
  ];

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    aiohttp
    pytest
    pytest-asyncio
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/aio-libs/pytest-aiohttp/";
    description = "Pytest plugin for aiohttp support";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
