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
  version = "2.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.6.1";

  src = fetchFromGitHub {
    owner = "romis2012";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ixhi23x28bg45146p23z26y38rlz445xr0inwgx7avh0rs7vwfx";
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
    maintainers = with maintainers; [ mjlbach ];
  };
}
