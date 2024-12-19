{
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  lib,
  manifestoo-core,
  pythonOlder,
  tomli,
}:
buildPythonPackage rec {
  pname = "hatch-odoo";
  version = "1.0.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "acsone";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-I3jaiG0Xu8B34q30p7zTs+FeBXUQiPKTAJLSVxE9gYE=";
  };

  buildInputs = [ hatch-vcs ];

  propagatedBuildInputs =
    [
      hatchling
      manifestoo-core
    ]
    ++ lib.optionals (pythonOlder "3.11") [
      tomli
    ];

  meta = with lib; {
    description = "A hatch plugin to develop and package Odoo projects";
    homepage = "https://github.com/acsone/hatch-odoo";
    license = licenses.mit;
    maintainers = with maintainers; [ yajo ];
  };
}
