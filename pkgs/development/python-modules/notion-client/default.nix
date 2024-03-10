{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, setuptools
, anyio
, httpx
, pytest-asyncio
, pytest-vcr
}:

buildPythonPackage rec {
  pname = "notion-client";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ramnes";
    repo = "notion-sdk-py";
    rev = "refs/tags/${version}";
    hash = "sha256-u10iPSbFPv9RewEYru3V6MpwhhySzmnymmv4CsefGC8=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    httpx
  ];

  # disable coverage options as they don't provide us value, and they break the default pytestCheckHook
  preCheck = ''
    sed -i '/addopts/d' ./setup.cfg
  '';

  nativeCheckInputs = [
    pytestCheckHook
    anyio
    pytest-asyncio
    pytest-vcr
  ];

  pythonImportsCheck = [
    "notion_client"
  ];

  meta = with lib; {
    description = "Python client for the official Notion API";
    homepage = "https://github.com/ramnes/notion-sdk-py";
    changelog = "https://github.com/ramnes/notion-sdk-py/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
