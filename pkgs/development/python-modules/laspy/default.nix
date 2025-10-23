{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  laszip,
  lazrs,
  setuptools,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "laspy";
  version = "2.6.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

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

  meta = with lib; {
    description = "Interface for reading/modifying/creating .LAS LIDAR files";
    mainProgram = "laspy";
    homepage = "https://github.com/laspy/laspy";
    changelog = "https://github.com/laspy/laspy/blob/${version}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = with maintainers; [ matthewcroughan ];
    teams = [ teams.geospatial ];
  };
}
