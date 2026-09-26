{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  click,
  click-log,
  shapely,
  numpy,
  trimesh,
  networkx,
  rtree,
  scipy,

  # tests
  geopandas,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "alphashape";
  version = "1.3.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bellockk";
    repo = "alphashape";
    tag = "v${finalAttrs.version}";
    hash = "sha256-T2wyU6fpiYRA1+9n//5EtOLhO1fzccQsie+gQj729Vs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    click-log
    shapely
    numpy
    trimesh
    networkx
    rtree
    scipy
  ];

  nativeCheckInputs = [
    geopandas
    pytestCheckHook
  ];

  disabledTests = [
    # TypeError
    "test_given_a_four_point_polygon_with_no_alpha_return_input"
    "test_given_a_point_return_a_point"
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch64 [
    # The tests compare the exact vertex order and orientation of every face
    # against a hard-coded Delaunay triangulation of a point set containing
    # exactly co-spherical subsets, for which the triangulation is not unique
    # and the resulting face order varies with the architecture's floating
    # point behavior: fails on aarch64 (darwin and linux) with an otherwise
    # equivalent shape. The substring match also deselects the
    # _with_dynamic_alpha variant of the test.
    "test_3_dimensional_regression"
  ];

  pythonImportsCheck = [ "alphashape" ];

  meta = {
    description = "Toolbox for generating n-dimensional alpha shapes";
    homepage = "https://github.com/bellockk/alphashape";
    changelog = "https://github.com/bellockk/alphashape/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
