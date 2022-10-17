{ lib
, aiohttp
, aresponses
, awesomeversion
, backoff
, buildPythonPackage
, deepmerge
, fetchFromGitHub
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, yarl
}:

buildPythonPackage rec {
  pname = "pyipp";
  version = "0.12.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
   owner = "ctalkington";
   repo = "python-ipp";
   rev = version;
   hash = "sha256-umlFGI0Y9cWF3N46yFztv0OlhLIzqhQF8e4quCmqn78=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    awesomeversion
    backoff
    deepmerge
    yarl
  ];

  checkInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'version = "0.0.0"' 'version = "${version}"' \
      --replace " --cov" ""
  '';

  pythonImportsCheck = [
    "pyipp"
  ];

  meta = with lib; {
    description = "Asynchronous Python client for Internet Printing Protocol (IPP)";
    homepage = "https://github.com/ctalkington/python-ipp";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
