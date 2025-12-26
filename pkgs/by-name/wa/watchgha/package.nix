{
  lib,
  python3Packages,
  fetchPypi,
}:
python3Packages.buildPythonApplication rec {
  pname = "watchgha";
  version = "2.5.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "watchgha";
    hash = "sha256-jjQk/X9kd8qhqgvivSIsvg0BOp6zh6yqpPiAS6ak/Ps=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    click
    dulwich
    exceptiongroup
    httpx
    rich
    trio
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
  ];

  pythonImportsCheck = [ "watchgha" ];

  meta = {
    description = "Live display of current GitHub action runs";
    mainProgram = "watch_gha_runs";
    homepage = "https://github.com/nedbat/watchgha";
    license = lib.licenses.apsl20;
    maintainers = with lib.maintainers; [ purcell ];
    platforms = lib.platforms.all;
  };
}
