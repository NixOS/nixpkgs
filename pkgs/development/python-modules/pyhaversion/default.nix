{
  lib,
  aiohttp,
  aresponses,
  awesomeversion,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyhaversion";
  version = "24.6.1";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = "pyhaversion";
    tag = version;
    hash = "sha256-UZ9236mERoz3WG9MfeN1ALKc8OjqpcbbIhiEsRYzn4I=";
  };

  postPatch = ''
    # Upstream doesn't set a version for the tagged releases
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0"' 'version = "${version}"'
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    awesomeversion
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyhaversion" ];

  disabledTests = [
    # Error fetching version information from HaVersionSource.SUPERVISOR Server disconnected
    "test_stable_version"
    "test_etag"
  ];

  meta = with lib; {
    description = "Python module to the newest version number of Home Assistant";
    homepage = "https://github.com/ludeeus/pyhaversion";
    changelog = "https://github.com/ludeeus/pyhaversion/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ makefu ];
  };
}
