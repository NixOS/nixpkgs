{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  pydbus,
  pygobject3,
  setuptools,
  strenum,
}:
buildPythonPackage rec {
  pname = "mprisify";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "zehkira";
    repo = "mprisify";
    tag = "v${version}";
    hash = "sha256-05i3N61cqRgGaBjYOEhxeCSV2wDh9yMaXTvEZ/JGrZo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pydbus
    pygobject3
    strenum
  ];

  pythonImportsCheck = [ "mprisify" ];

  meta = {
    description = "Python MPRIS server library for Linux media player apps";
    homepage = "https://gitlab.com/zehkira/mprisify";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ quadradical ];
  };
}
