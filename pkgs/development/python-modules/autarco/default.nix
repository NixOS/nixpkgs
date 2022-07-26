{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, yarl
}:

buildPythonPackage rec {
  pname = "autarco";
  version = "0.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "python-autarco";
    rev = "v${version}";
    hash = "sha256-ID1lCGfF6XHVv8Azd34a30hcsX17uMXo22stAhYH1Uo=";
  };

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

  postPatch = ''
    # Upstream doesn't set a version for the pyproject.toml
    substituteInPlace pyproject.toml \
      --replace "0.0.0" "${version}" \
      --replace "--cov" ""
  '';

  pythonImportsCheck = [
    "autarco"
  ];

  meta = with lib; {
    description = "Module for the Autarco Inverter";
    homepage = "https://github.com/klaasnicolaas/python-autarco";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
