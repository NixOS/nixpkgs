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
  version = "0.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "acsone";
    repo = pname;
    rev = version;
    sha256 = "sha256-+KM3tpeQ4e53bVhUeWUSfyuIzPRvWkjZi4S/gH4UHVY=";
  };

  buildInputs = [hatch-vcs];

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
    maintainers = with maintainers; [yajo];
  };
}
