{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "open-meteo";
  version = "0.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-open-meteo";
    rev = "v${version}";
    hash = "sha256-J106XeSglyqrFfP1ckbnDwfE7IikaNiBQ+m14PE2SBc=";
  };

  postPatch = ''
    # Upstream doesn't set a version for the pyproject.toml
    substituteInPlace pyproject.toml \
      --replace-fail "0.0.0" "${version}" \
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    mashumaro
    orjson
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  disabledTests = [
    # aiohttp api breakage
    "test_timeout"
  ];

  pythonImportsCheck = [ "open_meteo" ];

  meta = with lib; {
    changelog = "https://github.com/frenck/python-open-meteo/releases/tag/v${version}";
    description = "Python client for the Open-Meteo API";
    homepage = "https://github.com/frenck/python-open-meteo";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
