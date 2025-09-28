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
  version = "1.8.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "acsone";
    repo = "click-odoo";
    tag = version;
    hash = "sha256-dUTAu02iSA0YvF/nQYOyb5gzbT8zMedXXwU7yONBrl4=";
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
