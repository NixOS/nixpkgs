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
  version = "2.1.2";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "CircleUp";
    repo = pname;
    rev = version;
    sha256 = "007wrk4wdy97a81imgzxd6sm5dly9v7abmxh9fyfi0vp1p7s75bw";
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
