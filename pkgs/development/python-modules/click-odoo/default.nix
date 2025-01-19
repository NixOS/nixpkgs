{
  buildPythonPackage,
  click,
  fetchPypi,
  lib,
  nix-update-script,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "click-odoo";
  version = "1.7.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qPFuVSPni0gf1uX29KCgVnkehufXPNI5zuBldQbH220=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ click ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Odoo scripting helper library";
    mainProgram = "click-odoo";
    homepage = "https://github.com/acsone/click-odoo";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ yajo ];
  };
}
