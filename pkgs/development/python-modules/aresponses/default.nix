{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytest,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aresponses";
  version = "2.1.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CircleUp";
    repo = pname;
    rev = version;
    hash = "sha256-Ui9ZpWaVBfCbDlZH3EgHX32FIZtyTHnc/UXqtoEyFcw=";
  };

  propagatedBuildInputs = [ aiohttp ];

  buildInputs = [
    pytest
    pytest-asyncio
  ];

  nativeCheckInputs = [
    aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # Disable tests which requires network access
    "test_foo"
    "test_passthrough"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "aresponses" ];

  meta = with lib; {
    description = "Asyncio testing server";
    homepage = "https://github.com/circleup/aresponses";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };
}
