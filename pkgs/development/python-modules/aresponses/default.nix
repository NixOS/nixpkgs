{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, pytest
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aresponses";
  version = "2.1.0";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "CircleUp";
    repo = pname;
    rev = version;
    sha256 = "0dc1y4s6kpmr0ar63kkyghvisgbmb8qq5wglmjclrpzd5180mjcl";
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
    pytestCheckHook
    pytest-asyncio
  ];

  # Disable tests which requires network access
  disabledTests = [
    "test_foo"
    "test_passthrough"
  ];

  pythonImportsCheck = [ "aresponses" ];

  meta = with lib; {
    description = "Asyncio testing server";
    homepage = "https://github.com/circleup/aresponses";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };
}
