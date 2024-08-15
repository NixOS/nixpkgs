{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  nix-update-script,
}:
buildPythonPackage rec {
  pname = "factorio-rcon-py";
  version = "2.1.3";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "factorio_rcon_py";
    hash = "sha256-hL/ELSrfzQFmC9QDZSxkU/a+K0dIF+IU51IG8CsVEsM=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "factorio_rcon" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple Factorio RCON client";
    homepage = "https://github.com/mark9064/factorio-rcon-py";
    changelog = "https://github.com/mark9064/factorio-rcon-py/releases/tag/v${version}";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
