{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pytautulli";
  version = "23.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = "pytautulli";
    tag = version;
    hash = "sha256-5wE8FjLFu1oQkVqnWsbp253dsQ1/QGWC6hHSIFwLajY=";
  };

  postPatch = ''
    # Upstream is releasing with the help of a CI to PyPI, GitHub releases
    # are not in their focus
    substituteInPlace setup.py \
      --replace-fail 'version="main",' 'version="${version}",'

    # yarl 1.9.4 requires ports to be ints
    substituteInPlace pytautulli/models/host_configuration.py \
      --replace-fail "str(self.port)" "int(self.port)"

    # https://github.com/ludeeus/pytautulli/pull/44
    substituteInPlace pytautulli/decorator.py \
      --replace-fail "import async_timeout" ""
  '';

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [
    aresponses
    pytest-asyncio
  ];

  disabledTests = [
    # api url mismatch (port missing)
    "test_api_url"
  ];

  pythonImportsCheck = [ "pytautulli" ];

  meta = with lib; {
    description = "Python module to get information from Tautulli";
    homepage = "https://github.com/ludeeus/pytautulli";
    changelog = "https://github.com/ludeeus/pytautulli/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
