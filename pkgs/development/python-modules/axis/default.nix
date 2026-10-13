{
  lib,
  aiohttp,
  buildPythonPackage,
  faust-cchardet,
  fetchFromGitHub,
  orjson,
  packaging,
  pythonOlder,
  setuptools,
  tomli,
  tomli-w,
  xmltodict,
  zeroconf,
}:

buildPythonPackage (finalAttrs: {
  pname = "axis";
  version = "74";
  pyproject = true;

  disabled = pythonOlder "3.14";

  src = fetchFromGitHub {
    owner = "Kane610";
    repo = "axis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fWhQe4NklAva4znXUwYhrMdC/VCu4oZgwsyGuGd9csk=";
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
    orjson
    packaging
    tomli
    tomli-w
    xmltodict
    zeroconf
  ];

  # Tests requires a server on localhost
  doCheck = false;

  pythonImportsCheck = [ "axis" ];

  meta = {
    description = "Python library for communicating with devices from Axis Communications";
    homepage = "https://github.com/Kane610/axis";
    changelog = "https://github.com/Kane610/axis/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "axis";
  };
})
