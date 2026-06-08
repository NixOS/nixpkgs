{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonPackage (finalAttrs: {
  pname = "vsketch";
  version = "1.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-hRYcJsmSF5+4p4q/akO3PiLgwekw4uZi0JuHebd7S+Q=";
  };

  dependencies = with python3Packages; [
    cookiecutter
    matplotlib
    multiprocess
    numpy
    pnoise
    pyside6
    shapely
    vpype
    watchfiles
  ];

  build-system = with python3Packages; [
    poetry-core
  ];

  meta = {
    changelog = "https://github.com/abey79/vsketch/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Generative plotter art environment for Python";
    homepage = "https://github.com/abey79/vsketch";
    license = lib.licenses.mit;
    mainProgram = "vsk";
    maintainers = with lib.maintainers; [ kybe236 ];
  };
})
