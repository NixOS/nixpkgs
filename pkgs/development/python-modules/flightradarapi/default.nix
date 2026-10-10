{
  lib,
  beautifulsoup4,
  brotli,
  buildPythonPackage,
  curl-cffi,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "flightradarapi";
  version = "1.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JeanExtreme002";
    repo = "FlightRadarAPI";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u3Ow30B8aUaYe+9wHzm3lV3esc4eE2FHarC72SLxYro=";
  };

  sourceRoot = "${finalAttrs.src.name}/python";

  build-system = [ hatchling ];

  dependencies = [
    beautifulsoup4
    brotli
    curl-cffi
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestMarks = [ "integration" ];

  pythonImportsCheck = [ "FlightRadarAPI" ];

  meta = {
    description = "Unofficial Python SDK for FlightRadar24";
    homepage = "https://github.com/JeanExtreme002/FlightRadarAPI";
    changelog = "https://github.com/JeanExtreme002/FlightRadarAPI/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
