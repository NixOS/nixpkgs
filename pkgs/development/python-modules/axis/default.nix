{
  lib,
  aiohttp,
  buildPythonPackage,
  faust-cchardet,
  fetchFromGitHub,
  httpx,
  orjson,
  packaging,
  pythonOlder,
  setuptools,
  typing-extensions,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "axis";
  version = "69";
  pyproject = true;

  disabled = pythonOlder "3.14";

  src = fetchFromGitHub {
    owner = "Kane610";
    repo = "axis";
    tag = "v${version}";
    hash = "sha256-igeDyGKG235ooe/QrHjbya9WTCzwC8GfMoCwtpaBlR8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==82.0.1" "setuptools" \
      --replace-fail "wheel==0.47.0" "wheel"
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    faust-cchardet
    httpx
    orjson
    packaging
    typing-extensions
    xmltodict
  ];

  # Tests requires a server on localhost
  doCheck = false;

  pythonImportsCheck = [ "axis" ];

  meta = {
    description = "Python library for communicating with devices from Axis Communications";
    homepage = "https://github.com/Kane610/axis";
    changelog = "https://github.com/Kane610/axis/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "axis";
  };
}
