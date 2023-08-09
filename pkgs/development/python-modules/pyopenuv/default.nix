{ lib
, aiohttp
, aresponses
, backoff
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
  pname = "pyopenuv";
  version = "2023.02.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-EiTTck6hmOGSQ7LyZsbhnH1zgkH8GccejLdJaH2m0F8=";
  };

  patches = [
    # Remove asynctest, https://github.com/bachya/pyopenuv/pull/108
    (fetchpatch {
      name = "remove-asynctest.patch";
      url = "https://github.com/bachya/pyopenuv/commit/af15736b0d82ef811c3f380f5da32007752644fe.patch";
      hash = "sha256-5uQS3DoM91mhfyxLTNii3JBxwXIDK4/GwtadkVagjuw=";
    })
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    backoff
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-aiohttp
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Ignore the examples as they are prefixed with test_
    "examples/"
  ];

  pythonImportsCheck = [
    "pyopenuv"
  ];

  meta = with lib; {
    description = "Python API to retrieve data from openuv.io";
    homepage = "https://github.com/bachya/pyopenuv";
    changelog = "https://github.com/bachya/pyopenuv/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
