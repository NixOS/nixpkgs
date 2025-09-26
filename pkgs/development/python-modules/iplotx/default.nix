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

buildPythonPackage rec {
  pname = "iplotx";
  version = "0.6.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fabilab";
    repo = "iplotx";
    tag = version;
    hash = "sha256-k/psY/xwNuG5/1pLmJOpC8U3Il4v2cicwTy+pR9ZNC8=";
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
    "test_directed_graph"
    "test_display_shortest_path"
    "test_labels"
    "test_labels_and_colors"
  ];

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.flatten (lib.attrValues optional-dependencies);

  pythonImportsCheck = [ "iplotx" ];

  meta = {
    description = "Plot networkx from igraph and networkx";
    homepage = "https://iplotx.readthedocs.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jboy ];
  };
}
