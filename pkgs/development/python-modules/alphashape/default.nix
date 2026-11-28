{
  lib,
  stdenv,
  buildPythonPackage,
  click-log,
  click,
  fetchFromGitHub,
  geopandas,
  networkx,
  numpy,
  pytestCheckHook,
  rtree,
  scipy,
  setuptools,
  shapely,
  trimesh,
}:

buildPythonPackage (finalAttrs: {
  pname = "alphashape";
  version = "1.3.1";
  pyproject = true;

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
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "test_3_dimensional_regression"
    "test_3_dimensional_regression_with_dynamic_alpha"
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
