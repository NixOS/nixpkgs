{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "aiopvapi";
  version = "3.0.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sander76";
    repo = "aio-powerview-api";
    rev = "refs/tags/v${version}";
    hash = "sha256-+jhfp8gLEmL8TGPPN7QY8lw1SkV4sMSDb4VSq2OJ6PU=";
  };

  postPatch = ''
    # https://github.com/sander76/aio-powerview-api/pull/31
    substituteInPlace setup.py \
      --replace '"asyncio", ' ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aiopvapi"
  ];

  disabledTestPaths = [
    # https://github.com/sander76/aio-powerview-api/issues/32
    "tests/test_shade.py"
    "tests/test_scene.py"
    "tests/test_room.py"
    "tests/test_apiresource.py"
    "tests/test_hub.py"
    "tests/test_scene_members.py"
  ];

  meta = with lib; {
    description = "Python API for the PowerView API";
    homepage = "https://github.com/sander76/aio-powerview-api";
    changelog = "https://github.com/sander76/aio-powerview-api/releases/tag/v${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
