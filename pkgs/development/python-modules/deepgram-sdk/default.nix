{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, setuptools
, aiohttp
, dataclasses-json
, httpx
, typing-extensions
, verboselogs
, websockets
}:

buildPythonPackage rec {
  pname = "deepgram-sdk";
  version = "3.1.7";
  pyproject = true;

  disabled = pythonOlder "3.10";

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GZmVNvXBPv4o3ssssS8IEIRlPV1II1PpkISOhwj/Vo8=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    httpx
    websockets
    dataclasses-json
    aiohttp
    verboselogs
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "deepgram"
  ];

  meta = with lib; {
    description = "Official Python SDK for Deepgram.";
    homepage = "https://github.com/deepgram/deepgram-python-sdk";
    changelog = "https://github.com/deepgram/deepgram-python-sdk/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ offsetcyan ];
  };
}
