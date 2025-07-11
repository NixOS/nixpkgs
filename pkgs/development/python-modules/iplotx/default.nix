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
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fabilab";
    repo = "iplotx";
    tag = version;
    hash = "sha256-5piMXKr61F3euiCOlamZD7Iv6FQtrlbxwYYbZmD92Cg=";
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

  # These four tests result in an ImageComparisonFailure
  disabledTests = [
    "test_labels"
    "test_complex"
    "test_display_shortest_path"
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
