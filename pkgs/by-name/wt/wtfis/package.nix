{ lib
, python3
, fetchFromGitHub
}:

let
  pname = "wtfis";
  version = "0.9.1";
  src = fetchFromGitHub {
    owner = "pirxthepilot";
    repo = "wtfis";
    rev = "refs/tags/v${version}";
    hash = "sha256-nVcF7mPoWL5PNLh0W4FBPE7WVU72FidHpBZqMNl+Fd4=";
  };
in python3.pkgs.buildPythonApplication {
  inherit pname version src;

  format = "pyproject";

  nativeBuildInputs = [
    python3.pkgs.pythonRelaxDepsHook
  ];

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
    maintainers = [ lib.maintainers.AndersonTorres ];
  };
}
