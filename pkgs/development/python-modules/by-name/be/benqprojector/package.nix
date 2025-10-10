{
  lib,
  aiofiles,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  pyserial,
  pyserial-asyncio-fast,
}:

buildPythonPackage rec {
  pname = "benqprojector";
  version = "0.1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rrooggiieerr";
    repo = "benqprojector.py";
    tag = version;
    hash = "sha256-BttaLpjiybjeoJhOXfo6Qlox4bRqf9auvNg/wtm9gMQ=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    aiofiles
    pyserial
    pyserial-asyncio-fast
  ];

  # Test cases require an actual serial/telnet connection to a projector
  doCheck = false;

  pythonImportsCheck = [ "benqprojector" ];

  meta = rec {
    description = "Python library to control BenQ projectors";
    homepage = "https://github.com/rrooggiieerr/benqprojector.py";
    changelog = "${homepage}/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sephalon ];
  };
}
