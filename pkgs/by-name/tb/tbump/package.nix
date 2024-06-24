{
  lib,
  fetchPypi,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "tbump";
  version = "6.11.0";
  pyproject = true;

  disabled = python3Packages.pythonOlder "3.8";

  src = fetchPypi {
    inherit version;
    pname = "tbump";
    hash = "sha256-OF5xDu3wqKb/lZzx6fPP0XyHNhcTL8DsX2Ka8MNVyHA=";
  };

  pythonRelaxDeps = [ "tomlkit" ];


  build-system = with python3Packages; [ poetry-core ];

  dependencies = with python3Packages; [
    docopt
    schema
    packaging
    poetry-core
    tomlkit
    cli-ui
  ];

  meta = {
    description = "Bump software releases";
    homepage = "https://github.com/your-tools/tbump";
    license = lib.licenses.bsd3;
    mainProgram = "tbump";
    maintainers = with lib.maintainers; [ slashformotion ];
  };
}
