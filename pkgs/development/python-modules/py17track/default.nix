{
  lib,
  aiohttp,
  aresponses,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  pytz,
}:

buildPythonPackage rec {
  pname = "py17track";
  version = "2021.12.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    hash = "sha256-T0Jjdu6QC8rTqZwe4cdsBbs0hQXUY6CkrImCgYwWL9o=";
  };

  patches = [
    # This patch removes references to setuptools and wheel that are no longer
    # necessary and changes poetry to poetry-core, so that we don't need to add
    # unnecessary nativeBuildInputs.
    #
    #   https://github.com/bachya/py17track/pull/80
    #
    (fetchpatch {
      name = "clean-up-build-dependencies.patch";
      url = "https://github.com/bachya/py17track/commit/3b52394759aa50c62e2a56581e30cdb94003e2f1.patch";
      hash = "sha256-iLgklhEZ61rrdzQoO6rp1HGZcqLsqGNitwIiPNLNHQ4=";
    })
  ];

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    attrs
    pytz
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Ignore the examples directory as the files are prefixed with test_
    "examples/"
  ];

  pythonImportsCheck = [ "py17track" ];

  meta = with lib; {
    description = "Python library to track package info from 17track.com";
    homepage = "https://github.com/bachya/py17track";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
