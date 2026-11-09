{
  lib,
  aiohttp,
  aioresponses,
  awesomeversion,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  pytestCheckHook,
  pytest-asyncio,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-openevse-http";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "firstof9";
    repo = "python-openevse-http";
    tag = finalAttrs.version;
    hash = "sha256-l4/ZeIi6em5Dmp7O15Wg4brd4J2kTsIxSqLSGFS/Ihs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools-scm>=10.1.1" setuptools_scm
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    aiohttp
    awesomeversion
  ];

  nativeCheckInputs = [
    aioresponses
    freezegun
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [ "openevsehttp" ];

  meta = {
    description = "Python wrapper for OpenEVSE HTTP API";
    homepage = "https://github.com/firstof9/python-openevse-http";
    changelog = "https://github.com/firstof9/python-openevse-http/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
