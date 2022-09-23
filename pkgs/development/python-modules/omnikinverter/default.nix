{ lib
, aiohttp
, aresponses
, asynctest
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, yarl
}:

buildPythonPackage rec {
  pname = "omnikinverter";
  version = "0.8.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "python-omnikinverter";
    rev = "v${version}";
    hash = "sha256-OQWk+ae+hSLLdH0uLVPauoNeQpXgxkvflXFyaiFe108=";
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
    asynctest
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
    "omnikinverter"
  ];

  meta = with lib; {
    description = "Python module for the Omnik Inverter";
    homepage = "https://github.com/klaasnicolaas/python-omnikinverter";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
