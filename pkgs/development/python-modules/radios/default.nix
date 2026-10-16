{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  aiodns,
  aiohttp,
  awesomeversion,
  mashumaro,
  orjson,
  probatio,
  pycares,
  yarl,
  aioresponses,
  pycountry,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy_6,
}:

buildPythonPackage rec {
  pname = "radios";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-radios";
    tag = "v${version}";
    hash = "sha256-AFeW+Pg69ZfRx8AqnfaAjQyMuGGXK6/dfGbSPqVIxjE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  '';

  pythonRelaxDeps = [ "pycountry" ];

  build-system = [
    poetry-core
  ];

  dependencies = [
    aiodns
    aiohttp
    awesomeversion
    mashumaro
    orjson
    probatio
    pycares
    yarl
  ];

  nativeCheckInputs = [
    aioresponses
    pycountry
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy_6
  ];

  disabledTestPaths = [
    "tests/test_search.py::test_search_more_filters" # AssertionError: assert 'jazz%2Cblues' == 'jazz,blues'
    "tests/test_search.py::test_search_lowercases_tags_and_languages" # AssertionError: assert 'jazz%2Cblues' == 'jazz,blues'
    "tests/test_stations.py::test_stations_by_uuid" # AssertionError: assert <MultiDictPro...5f7b56c5ec3')> == {'uuids': '6c...35...
    "tests/test_stations.py::test_stations_by_url" # AssertionError: assert <MultiDictPro...LPSTR09.mp3')> == {'url': 'http...TL...
  ];

  pythonImportsCheck = [ "radios" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    changelog = "https://github.com/frenck/python-radios/releases/tag/v${version}";
    description = "Asynchronous Python client for the Radio Browser API";
    homepage = "https://github.com/frenck/python-radios";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
