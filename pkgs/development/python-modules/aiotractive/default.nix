{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  orjson,
  setuptools,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiotractive";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zhulik";
    repo = "aiotractive";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wRV/ZQ2T3Dlrmq6jY5IatrGr07uxPFWcVoMiJN+md88=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${finalAttrs.version}"'
  '';

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "orjson" ];

  dependencies = [
    aiohttp
    orjson
    yarl
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aiotractive" ];

  meta = {
    description = "Python client for the Tractive REST API";
    homepage = "https://github.com/zhulik/aiotractive";
    changelog = "https://github.com/zhulik/aiotractive/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
