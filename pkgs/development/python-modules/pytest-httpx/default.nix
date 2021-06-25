{ lib
, buildPythonPackage
, fetchFromGitHub
, httpx
, pytest
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-httpx";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "Colin-b";
    repo = "pytest_httpx";
    rev = "v${version}";
    sha256 = "sha256-Awhsm8jmoCZTBnfrrauLxAEKtpxTzjPMXmx7HR0f/g4=";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    httpx
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pytest_httpx" ];

  meta = with lib; {
    description = "Send responses to httpx";
    homepage = "https://github.com/Colin-b/pytest_httpx";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
