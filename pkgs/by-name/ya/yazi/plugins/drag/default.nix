{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "drag.yazi";
  version = "0-unstable-2026-02-21";

  src = fetchFromGitHub {
    owner = "Joao-Queiroga";
    repo = "drag.yazi";
    rev = "3dff129c52b30d8c08015e6f4ef8f2c07b299d4b";
    hash = "sha256-nmFlh+zW3aOU+YjbfrAWQ7A6FlGaTDnq2N2gOZ5yzzc=";
  };

  meta = {
    description = "Yazi plugin to drag and drop files using ripdrag";
    homepage = "https://github.com/Joao-Queiroga/drag.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gibbert ];
  };
}
