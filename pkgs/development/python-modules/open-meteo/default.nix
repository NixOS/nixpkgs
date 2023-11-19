{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pydantic
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "open-meteo";
  version = "0.2.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-open-meteo";
    rev = "v${version}";
    sha256 = "0i8jmhd29vvkpfxs9l5wy8525ngs79mnc7si2j9b1nc41xrv91f6";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    aresponses
    pydantic
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    # Upstream doesn't set a version for the pyproject.toml
    substituteInPlace pyproject.toml \
      --replace "0.0.0" "${version}" \
      --replace "--cov" "" \
      --replace 'aiohttp = "^3.8.1"' 'aiohttp = "^3.8.0"'
  '';

  pythonImportsCheck = [
    "open_meteo"
  ];

  meta = with lib; {
    description = "Python client for the Open-Meteo API";
    homepage = "https://github.com/frenck/python-open-meteo";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
