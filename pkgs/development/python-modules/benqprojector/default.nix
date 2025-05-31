{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  pyserial,
  pyserial-asyncio-fast,
}:

buildPythonPackage rec {
  pname = "benqprojector";
  version = "0.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rrooggiieerr";
    repo = "benqprojector.py";
    tag = version;
    hash = "sha256-Ys2C44kr5gd6tXO51OFRx4YVKVRGLfFPCYDFGt+gN0c=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    pyserial
    pyserial-asyncio-fast
  ];

  # Test cases require an actual serial/telnet connection to a projector
  doCheck = false;

  pythonImportsCheck = [ "benqprojector" ];

  meta = rec {
    description = "Python library to control BenQ projectors";
    homepage = "https://github.com/rrooggiieerr/benqprojector.py";
    changelog = "${homepage}/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sephalon ];
  };
}
