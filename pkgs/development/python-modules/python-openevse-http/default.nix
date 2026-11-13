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
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "firstof9";
    repo = "python-openevse-http";
    tag = finalAttrs.version;
    hash = "sha256-5PGRmUP6f7/dis4H1Am//LvIO8OpDCGx773i4H+B3Ls=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=84.0.0" setuptools \
      --replace-fail "setuptools-scm>=10.3.4" setuptools_scm
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
