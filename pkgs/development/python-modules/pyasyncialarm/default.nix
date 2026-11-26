{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  dicttoxml2,
  xmltodict,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyasyncialarm";
  version = "3.1.1";
  pyproject = true;

  disabled = pythonOlder "3.14";

  src = fetchFromGitHub {
    owner = "bigmoby";
    repo = "pyasyncialarm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YcmJS/0BGgWuDZOR1tlECSr4CeW4+T5AnboDjDP/K08=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==84.0.0" "setuptools"
  '';

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    dicttoxml2
    xmltodict
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyasyncialarm" ];

  meta = {
    description = "Simple library to interface with iAlarm systems, built for use with Home Assistant";
    homepage = "https://github.com/bigmoby/pyasyncialarm";
    changelog = "https://github.com/bigmoby/pyasyncialarm/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
