{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-yate";
  version = "0.5.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "eventphone";
    repo = "python-yate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/tlDme4RmO9XH5PNTvK2yVzbF+iDNeCY21nArq6NU+g=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
    async-timeout
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "yate" ];

  meta = {
    description = "Python library for the yate telephony engine";
    mainProgram = "yate_callgen";
    homepage = "https://github.com/eventphone/python-yate";
    changelog = "https://github.com/eventphone/python-yate/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ clerie ];
  };
})
