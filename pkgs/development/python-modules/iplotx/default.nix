{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  igraph,
  matplotlib,
  networkx,
  numpy,
  pandas,
  pylint,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "iplotx";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fabilab";
    repo = "iplotx";
    tag = finalAttrs.version;
    hash = "sha256-pTSY7eEYKwBSDttxZqauGCofYK5SFaxjJLXYBwSr3ew=";
  };

  build-system = [ hatchling ];

  dependencies = [
    matplotlib
    numpy
    pandas
    pylint
  ];

  pythonRelaxDeps = [ "pylint" ];

  optional-dependencies = {
    igraph = [ igraph ];
    networkx = [ networkx ];
  };

  postPatch = ''
    # silence matplotlib warning
    export MPLCONFIGDIR=$(mktemp -d)
  '';

  disabledTests = [
    # These tests result in an ImageComparisonFailure
    "test_complex"
    "test_complex_rotatelabels"
    "test_curved_waypoints"
    "test_directed_graph"
    "test_display_shortest_path"
    "test_labels"
    "test_labels_and_colors"
    "test_vertex_labels"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [ "iplotx" ];

  meta = {
    description = "Plot networkx from igraph and networkx";
    homepage = "https://iplotx.readthedocs.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jboy ];
  };
})
