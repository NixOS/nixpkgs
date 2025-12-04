{
  lib,
  python3,
  fetchFromGitHub,
}:

let
  pname = "wtfis";
  version = "0.14.0";
  src = fetchFromGitHub {
    owner = "pirxthepilot";
    repo = "wtfis";
    tag = "v${version}";
    hash = "sha256-XFitQY30hK3byVevqndSAkG08ztwY1BIpJEYhY3PzTs=";
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
