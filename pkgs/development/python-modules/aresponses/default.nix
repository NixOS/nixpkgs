{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, pytest
, pytest-asyncio
, pytest-cov
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aresponses";
  version = "2.1.4";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "CircleUp";
    repo = pname;
    rev = version;
    sha256 = "sha256-crMiMZ2IDuYDFt8Bixg3NRhlUa2tqmfzd7ZeHM+2Iu4=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  buildInputs = [
    pytest
    pytest-asyncio
  ];

  checkInputs = [
    aiohttp
    pytest-asyncio
    pytest-cov
    pytestCheckHook
  ];

  # Disable tests which requires network access
  disabledTests = [
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
