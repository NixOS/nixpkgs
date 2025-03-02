{
  buildPythonPackage,
  click,
  fetchFromGitHub,
  lib,
  nix-update-script,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "click-odoo";
  version = "1.7.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "acsone";
    repo = "click-odoo";
    tag = version;
    hash = "sha256-lNhhaUTFbvUTkMpTZZmTSVjhh/I43l9AeWvx8YzB8OA=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ click ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Odoo scripting helper library";
    mainProgram = "click-odoo";
    homepage = "https://github.com/acsone/click-odoo";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ yajo ];
  };
}
