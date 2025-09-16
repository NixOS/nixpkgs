{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "timetagger_cli";
  version = "25.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "almarklein";
    repo = "timetagger_cli";
    tag = "v${version}";
    hash = "sha256-UklsHcVyCpWDHOxu+oB8RvwY+laEBFnDyjejS/GzgHE=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    requests
    toml
    dateparser
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "timetagger_cli" ];

  meta = with lib; {
    description = "Track your time from the command-line";
    homepage = "https://github.com/almarklein/timetagger_cli";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ matthiasbeyer ];
    mainProgram = "timetagger";
  };
}
