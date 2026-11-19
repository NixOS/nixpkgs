{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "drag.yazi";
  version = "0-unstable-2026-11-17";

  src = fetchFromGitHub {
    owner = "Joao-Queiroga";
    repo = "drag.yazi";
    rev = "94de073557520c96af2c9382cd6233642f1fbc16";
    hash = "sha256-nmFlh+zW3aOU+YjbfrAWQ7A6FlGaTDnq2N2gOZ5yzzc=";
  };

  meta = {
    description = "Yazi plugin to drag and drop files using ripdrag";
    homepage = "https://github.com/Joao-Queiroga/drag.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gibbert ];
  };
}
