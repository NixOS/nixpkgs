{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, mashumaro
, poetry-core
, pyjwt
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, setuptools
, syrupy
}:

buildPythonPackage rec {
  pname = "aioautomower";
  version = "2024.2.10";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "Thomas55555";
    repo = "aioautomower";
    rev = "refs/tags/${version}";
    hash = "sha256-NRcLyuU5FFIKJALUrx5iVSihzgO6ljqaqlhbs+y2E4Q=";
  };

  postPatch = ''
    # Upstream doesn't set a version
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  '';

  nativeBuildInputs = [
    poetry-core
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
    mashumaro
    pyjwt
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [
    "aioautomower"
  ];

  pytestFlagsArray = [
    "--snapshot-update"
  ];

  disabledTests = [
    # File is missing
    "test_standard_mower"
  ];

  meta = with lib; {
    description = "Module to communicate with the Automower Connect API";
    homepage = "https://github.com/Thomas55555/aioautomower";
    changelog = "https://github.com/Thomas55555/aioautomower/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
