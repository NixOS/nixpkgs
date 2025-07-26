{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "odoorpc";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "OCA";
    repo = "odoorpc";
    tag = "v${version}";
    sha256 = "sha256-59txgRhZ6CWCamv3BVSGDDZ5Q1RDW7wC1TEsen/OD6M=";
  };

  pyproject = true;

  build-system = [ setuptools ];

  pythonImportsCheck = [ "odoorpc" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "OdooRPC is a Python library to interact with Odoo servers using the JSON-RPC protocol.";
    homepage = "https://github.com/OCA/odoorpc";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ yajo ];
  };
}
