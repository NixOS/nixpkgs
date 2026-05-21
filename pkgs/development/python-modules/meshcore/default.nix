{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  # dependencies
  bleak,
  pycayennelpp,
  pyserial-asyncio-fast,
}:

buildPythonPackage (finalAttrs: {
  pname = "meshcore";
  version = "2.2.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "meshcore-dev";
    repo = "meshcore_py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-S3hyA2TsgEHwB0gv5xFMTbwnAoGbceq0C5+8MBedD70=";
  };

  build-system = [ hatchling ];

  dependencies = [
    bleak
    pycayennelpp
    pyserial-asyncio-fast
  ];

  pythonImportsCheck = [ "meshcore" ];

  meta = {
    description = "Python library for communicating with meshcore companion radios";
    homepage = "https://github.com/meshcore-dev/meshcore_py";
    changelog = "https://github.com/meshcore-dev/meshcore_py/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ haylin ];
  };
})
