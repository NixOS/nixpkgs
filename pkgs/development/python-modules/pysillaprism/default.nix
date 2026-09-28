{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pysillaprism";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ebaschiera";
    repo = "pysillaprism";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EkaHeudneVUlbH1dxF1uIXEnh4tfIppp9DzFz9L2GuM=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "pysillaprism" ];

  meta = {
    description = "Transport-agnostic client library for the Silla Prism EV wallbox over MQTT";
    homepage = "https://github.com/ebaschiera/pysillaprism";
    changelog = "https://github.com/ebaschiera/pysillaprism/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
