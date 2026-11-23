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
  version = "1.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JeanExtreme002";
    repo = "FlightRadarAPI";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iNRZVZWnNSbgdK/lVeL/rtZmeL4CmIKTq5kdhk8/hBs=";
  };

  sourceRoot = "${finalAttrs.src.name}/python";

  build-system = [ hatchling ];

  dependencies = [
    beautifulsoup4
    brotli
    curl-cffi
  ];

  __darwinAllowLocalNetworking = true;

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
