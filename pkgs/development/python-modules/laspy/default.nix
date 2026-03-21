{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # depenencies
  laszip,
  lazrs,
  numpy,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "laspy";
  version = "2.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "laspy";
    repo = "laspy";
    tag = finalAttrs.version;
    hash = "sha256-/wvwUE+lzBgAZVtLB05Fpuq0ElajMxWqCIa1Y3sjB5k=";
  };

  build-system = [ hatchling ];

  dependencies = [
    numpy
    laszip
    lazrs # much faster laz reading, see https://laspy.readthedocs.io/en/latest/installation.html#laz-support
  ];

  pythonImportsCheck = [
    "laspy"
    # `laspy` supports multiple backends and detects them dynamically.
    # We check their importability to make sure they are all working.
    "laszip"
    "lazrs"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Interface for reading/modifying/creating .LAS LIDAR files";
    mainProgram = "laspy";
    homepage = "https://github.com/laspy/laspy";
    changelog = "https://github.com/laspy/laspy/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    teams = [ lib.teams.geospatial ];
  };
})
