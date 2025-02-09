{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, mashumaro
, orjson
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, yarl
}:

buildPythonPackage rec {
  pname = "elgato";
  version = "5.1.2";
  format = "pyproject";

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-elgato";
    rev = "refs/tags/v${version}";
    hash = "sha256-NAU4tr0oaAPPrOUZYl9WoGOM68MlrBqGewHBIiIv2XY=";
  };

  postPatch = ''
    # Upstream doesn't set a version for the pyproject.toml
    substituteInPlace pyproject.toml \
      --replace "0.0.0" "${version}" \
      --replace "--cov" ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    mashumaro
    orjson
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "elgato"
  ];

  meta = with lib; {
    description = "Python client for Elgato Key Lights";
    homepage = "https://github.com/frenck/python-elgato";
    changelog = "https://github.com/frenck/python-elgato/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
