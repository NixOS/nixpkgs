{ lib
, buildPythonPackage
, fetchFromGitHub
, httpx
, pytest
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytest-httpx";
  version = "0.14.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Colin-b";
    repo = "pytest_httpx";
    rev = "v${version}";
    sha256 = "sha256-B95HJOQ0g/ZqKgrJWCRMXD8Z81S06nH/O/PgA4tdtnY=";
  };

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    httpx
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "httpx==0.20.*" "httpx"
  '';

  pythonImportsCheck = [
    "pytest_httpx"
  ];

  meta = with lib; {
    description = "Send responses to httpx";
    homepage = "https://github.com/Colin-b/pytest_httpx";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
