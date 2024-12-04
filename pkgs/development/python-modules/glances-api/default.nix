{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  httpx,
  poetry-core,
  pytest-asyncio,
  pytest-httpx,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "glances-api";
  version = "0.8.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-glances-api";
    rev = "refs/tags/${version}";
    hash = "sha256-QAnwFX53jf7yWWa308/XTARNw5Qeo9K2zfD+6+HiFuM=";
  };

  patches = [
    (fetchpatch2 {
      name = "pytest-httpx-compat.patch";
      url = "https://github.com/home-assistant-ecosystem/python-glances-api/commit/f193472a25469e7e4b946f9a1c3a7a95949c6c04.patch";
      hash = "sha256-hFeWv2WdbdeoaHgAOmwtBwWwPLjJzyurTZDV98qR7F8=";
    })
  ];

  build-system = [ poetry-core ];

  dependencies = [ httpx ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpx
    pytestCheckHook
  ];

  pythonImportsCheck = [ "glances_api" ];

  meta = with lib; {
    description = "Python API for interacting with Glances";
    homepage = "https://github.com/home-assistant-ecosystem/python-glances-api";
    changelog = "https://github.com/home-assistant-ecosystem/python-glances-api/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
