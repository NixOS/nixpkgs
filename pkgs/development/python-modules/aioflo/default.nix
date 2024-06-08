{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  poetry-core,
  pytest-aiohttp,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aioflo";
  version = "2021.11.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    hash = "sha256-7NrOoc1gi8YzZaKvCnHnzAKPlMnMhqxjdyZGN5H/8TQ=";
  };

  patches = [
    # This patch removes references to setuptools and wheel that are no longer
    # necessary and changes poetry to poetry-core, so that we don't need to add
    # unnecessary nativeBuildInputs.
    #
    #   https://github.com/bachya/aioflo/pull/65
    #
    (fetchpatch {
      name = "clean-up-build-dependencies.patch";
      url = "https://github.com/bachya/aioflo/commit/f38d3f6427777ab0eeb56177943679e2570f0634.patch";
      hash = "sha256-iLgklhEZ61rrdzQoO6rp1HGZcqLsqGNitwIiPNLNHQ4=";
    })
  ];

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ aiohttp ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    aresponses
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioflo" ];

  meta = with lib; {
    description = "Python library for Flo by Moen Smart Water Detectors";
    homepage = "https://github.com/bachya/aioflo";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
