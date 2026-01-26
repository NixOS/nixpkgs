{
  lib,
  python3Packages,
  fetchPypi,
}:
python3Packages.buildPythonApplication rec {
  pname = "watchgha";
  version = "2.7.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "watchgha";
    hash = "sha256-EWk/h5eusjgowj6C6h8RgAxkgqju4Ni3A/wWaeDQ3GQ=";
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
