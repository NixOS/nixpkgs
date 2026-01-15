{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  laszip,
  lazrs,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "laspy";
  version = "2.6.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zpy5oYUosqK5hVg99ApN6mjN2nmV5H5LALbUjfDojao=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    numpy
    laszip
    lazrs # much faster laz reading, see https://laspy.readthedocs.io/en/latest/installation.html#laz-support
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "laspy"
    # `laspy` supports multiple backends and detects them dynamically.
    # We check their importability to make sure they are all working.
    "laszip"
    "lazrs"
  ];

  meta = {
    description = "Interface for reading/modifying/creating .LAS LIDAR files";
    mainProgram = "laspy";
    homepage = "https://github.com/laspy/laspy";
    changelog = "https://github.com/laspy/laspy/blob/${version}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    teams = [ lib.teams.geospatial ];
  };
}
