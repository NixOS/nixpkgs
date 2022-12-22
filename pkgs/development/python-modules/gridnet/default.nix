{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, aiohttp
, yarl
, aresponses
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "gridnet";
  version = "4.1.0";

  disabled = pythonOlder "3.9";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "python-gridnet";
    rev = "refs/tags/v${version}";
    hash = "sha256-/UBZVbDRZMYHDrgifpYSTygAQTBiqgZ0tRGncE3GeT4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "0.0.0" "${version}" \
      --replace "--cov" ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    yarl
  ];

  checkInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "gridnet" ];

  meta = with lib; {
    description = "Asynchronous Python client for NET2GRID devices";
    homepage = "https://github.com/klaasnicolaas/python-gridnet";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
