{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "timetagger_cli";
  version = "24.7.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "almarklein";
    repo = "timetagger_cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-PEuSFDkBqDegZD0Nh8jRJ/zm/6vT2lq7/llbXBvojkc=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    requests
    toml
  ];

  # Project has no tests
  doCheck = false;

  meta = with lib; {
    description = "Track your time from the command-line";
    homepage = "https://github.com/almarklein/timetagger_cli";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ matthiasbeyer ];
    mainProgram = "timetagger";
  };
}
