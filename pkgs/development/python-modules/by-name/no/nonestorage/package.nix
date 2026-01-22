{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
}:

buildPythonPackage rec {
  pname = "nonestorage";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nonebot";
    repo = "nonestorage";
    tag = "v${version}";
    hash = "sha256-Y8Ywpp5/FRT8jIhSaMtuzMXs3UJROh5SrFdIZD7ysBA=";
  };

  build-system = [ hatchling ];

  pythonImportsCheck = [ "nonestorage" ];

  # no test
  doCheck = false;

  meta = {
    description = "Simple library that provides local storage folder detect";
    homepage = "https://github.com/nonebot/nonestorage";
    changelog = "https://github.com/nonebot/nonestorage/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
  };
}
