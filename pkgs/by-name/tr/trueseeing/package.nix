{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "trueseeing";
  version = "2.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alterakey";
    repo = "trueseeing";
    rev = "refs/tags/v${version}";
    hash = "sha256-2KELqHa6lw9wdJBaC90vTZSjD7tfkr3K6yDNhqBQrR0=";
  };

  build-system = with python3.pkgs; [
    flit-core
  ];

  pythonRelaxDeps = true;

  dependencies = with python3.pkgs; [
    aiohttp
    asn1crypto
    importlib-metadata
    jinja2
    lief
    lxml
    progressbar2
    prompt-toolkit
    pyaxmlparser
    pypubsub
    pyyaml
    termcolor
    zstandard
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "trueseeing"
  ];

  meta = {
    description = "Non-decompiling Android vulnerability scanner";
    homepage = "https://github.com/alterakey/trueseeing";
    changelog = "https://github.com/alterakey/trueseeing/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.fab ];
    mainProgram = "trueseeing";
  };
}
