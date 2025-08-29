{
  lib,
  python3,
  fetchFromGitHub,
}:

let
  pname = "wtfis";
  version = "0.13.0";
  src = fetchFromGitHub {
    owner = "pirxthepilot";
    repo = "wtfis";
    tag = "v${version}";
    hash = "sha256-YEuj4WgRhAXMbYVcSy5eLH8284EGn3dtP2UEjXCA720=";
  };
in
python3.pkgs.buildPythonApplication {
  inherit pname version src;

  format = "pyproject";

  propagatedBuildInputs = [
    python3.pkgs.hatchling
    python3.pkgs.pydantic
    python3.pkgs.python-dotenv
    python3.pkgs.rich
    python3.pkgs.shodan
  ];

  pythonRelaxDeps = [
    "pydantic"
    "python-dotenv"
    "requests"
    "rich"
    "shodan"
    "types-requests"
  ];

  meta = {
    homepage = "https://github.com/pirxthepilot/wtfis";
    description = "Passive hostname, domain and IP lookup tool for non-robots";
    mainProgram = "wtfis";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
