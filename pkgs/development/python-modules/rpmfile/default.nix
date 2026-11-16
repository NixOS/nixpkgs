{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-vcs,
  hatchling,
}:

buildPythonPackage rec {
  pname = "rpmfile";
  version = "2.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-j/xE0V+NK2ytHqiFsJ4cpfF0RTLCRxBVTz/khzUG6do=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  # Tests access the internet
  doCheck = false;

  pythonImportsCheck = [ "rpmfile" ];

  meta = {
    description = "Read rpm archive files";
    homepage = "https://github.com/srossross/rpmfile";
    changelog = "https://github.com/srossross/rpmfile/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "rpmfile";
  };
}
