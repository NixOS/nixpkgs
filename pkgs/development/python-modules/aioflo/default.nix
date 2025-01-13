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
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = "aioflo";
    tag = version;
    hash = "sha256-7NrOoc1gi8YzZaKvCnHnzAKPlMnMhqxjdyZGN5H/8TQ=";
  };

  patches = [
    (fetchpatch {
      # Clean-up, https://github.com/bachya/aioflo/pull/65
      name = "clean-up-build-dependencies.patch";
      url = "https://github.com/bachya/aioflo/commit/f38d3f6427777ab0eeb56177943679e2570f0634.patch";
      hash = "sha256-iLgklhEZ61rrdzQoO6rp1HGZcqLsqGNitwIiPNLNHQ4=";
    })
  ];

  build-system = [ poetry-core ];

  dependencies = [ aiohttp ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    aresponses
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioflo" ];

  disabledTests = [
    # test is out-dated
    "test_system_modes"
  ];

  meta = with lib; {
    description = "Python library for Flo by Moen Smart Water Detectors";
    homepage = "https://github.com/bachya/aioflo";
    changelog = "https://github.com/bachya/aioflo/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
