{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,

  # propagated
  aiohttp,

  # tests
  pytest-asyncio,
  pytestCheckHook,
}:

let
  pname = "pyoctoprintapi";
  version = "0.1.14";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rfleming71";
    repo = "pyoctoprintapi";
    tag = "v${version}";
    hash = "sha256-DKqkT0Wyxf4grXBqei9IYBGMOgPxjzuo955M/nHDLo8=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ aiohttp ];

  pythonImportsCheck = [ "pyoctoprintapi" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    description = "Simple async wrapper around the Octoprint API";
    homepage = "https://github.com/rfleming71/pyoctoprintapi";
    changelog = "https://github.com/rfleming71/pyoctoprintapi/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
