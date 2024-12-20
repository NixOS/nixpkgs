{
  lib,
  python3,
  fetchFromGitHub,
}:

let
  pname = "wtfis";
  version = "0.10.1";
  src = fetchFromGitHub {
    owner = "pirxthepilot";
    repo = "wtfis";
    rev = "refs/tags/v${version}";
    hash = "sha256-+BJmAFjmj3z/sKJ/L/y6hTClesulpQTpDL9cUNRi6e8=";
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
