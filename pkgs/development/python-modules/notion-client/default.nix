{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, anyio
, httpx
, pytest-asyncio
, pytest-vcr
}:

buildPythonPackage rec {
  pname = "notion-client";
  version = "2.0.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ramnes";
    repo = "notion-sdk-py";
    rev = version;
    sha256 = "sha256-zfG1OgH/2ytDUC+ogIY9/nP+xkgjiMt9+HVcWEMXoj8=";
  };

  propagatedBuildInputs = [
    httpx
  ];

  # disable coverage options as they don't provide us value, and they break the defalt pytestCheckHook
  preCheck = ''
    sed -i '/addopts/d' ./setup.cfg
  '';

  checkInputs = [
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
