{
  lib,
  buildPythonPackage,
  click,
  click-log,
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
  ];

  pythonImportsCheck = [ "alphashape" ];

  meta = with lib; {
    description = "Toolbox for generating n-dimensional alpha shapes";
    homepage = "https://github.com/bellockk/alphashape";
    changelog = "https://github.com/bellockk/alphashape/releases/tag/${finalAttrs.src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
})
