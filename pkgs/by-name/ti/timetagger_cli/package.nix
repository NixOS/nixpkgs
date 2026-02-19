{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "timetagger_cli";
  version = "25.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "almarklein";
    repo = "timetagger_cli";
    tag = "v${finalAttrs.version}";
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

  meta = {
    description = "Track your time from the command-line";
    homepage = "https://github.com/almarklein/timetagger_cli";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    mainProgram = "timetagger";
  };
})
