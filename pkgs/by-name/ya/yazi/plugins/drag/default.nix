{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "drag.yazi";
  version = "0-unstable-2025-08-29";

  src = fetchFromGitHub {
    owner = "Joao-Queiroga";
    repo = "drag.yazi";
    rev = "27606689cb82c56a19c052a7b7935cd9b1466bab";
    hash = "sha256-ITkZjpwWXni4tQpDhUiVvtPrEkAo6RISgCH594NgpYE=";
  };

  meta = {
    description = "Yazi plugin to drag and drop files using ripdrag";
    homepage = "https://github.com/Joao-Queiroga/drag.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gibbert ];
  };
}
