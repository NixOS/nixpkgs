{ lib
, async-timeout
, buildPythonPackage
, curio
, fetchFromGitHub
, flask
, pytest-asyncio
, pytest-trio
, pythonOlder
, pytestCheckHook
, trio
, yarl
}:

buildPythonPackage rec {
  pname = "python-socks";
  version = "2.0.3";
  format = "setuptools";

  disabled = pythonOlder "3.6.1";

  src = fetchFromGitHub {
    owner = "romis2012";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tVoBon9HF9MTOK+dN9g58fQO706ElNlCeULx//7hPWA=";
  };

  propagatedBuildInputs = [
    trio
    curio
    async-timeout
  ];

  checkInputs = [
    flask
    pytest-asyncio
    pytest-trio
    pytestCheckHook
    yarl
  ];

  pythonImportsCheck = [
    "python_socks"
  ];

  meta = with lib; {
    description = "Core proxy client (SOCKS4, SOCKS5, HTTP) functionality for Python";
    homepage = "https://github.com/romis2012/python-socks";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
