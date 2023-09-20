{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, yarl
, aresponses
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "directv";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "ctalkington";
    repo = "python-directv";
    rev = version;
    sha256 = "19jckf6qvl8fwi8yff1qy8c44xdz3zpi1ip1md6zl2c503qc91mk";
  };

  propagatedBuildInputs = [
    aiohttp
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "directv" ];

  meta = with lib; {
    description = "Asynchronous Python client for DirecTV (SHEF)";
    homepage = "https://github.com/ctalkington/python-directv";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
