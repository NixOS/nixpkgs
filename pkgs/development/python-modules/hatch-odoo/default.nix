{
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  lib,
  manifestoo-core,
}:
buildPythonPackage rec {
  pname = "hatch-odoo";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "acsone";
    repo = "hatch-odoo";
    tag = version;
    sha256 = "sha256-I3jaiG0Xu8B34q30p7zTs+FeBXUQiPKTAJLSVxE9gYE=";
  };

  buildInputs = [ hatch-vcs ];

  propagatedBuildInputs = [
    hatchling
    manifestoo-core
  ];

  meta = {
    description = "Hatch plugin to develop and package Odoo projects";
    homepage = "https://github.com/acsone/hatch-odoo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yajo ];
  };
}
