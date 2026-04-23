{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  hatchling,
  beautifulsoup4,
  bleach,
  defusedxml,
  jinja2,
  jupyter-core,
  jupyterlab-pygments,
  markupsafe,
  mistune,
  nbclient,
  packaging,
  pandocfilters,
  pygments,
  traitlets,
  importlib-metadata,
  flaky,
  ipykernel,
  ipywidgets,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "nbconvert";
  version = "7.17.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NNDQp+c848urbFquj09Gh5coCwH9i9LKdG2oVp7d19I=";
  };

  # Add $out/share/jupyter to the list of paths that are used to search for
  # various exporter templates
  patches = [ ./templates.patch ];

  postPatch = ''
    substituteAllInPlace ./nbconvert/exporters/templateexporter.py
  '';

  build-system = [ hatchling ];

  dependencies = [
    beautifulsoup4
    bleach
    defusedxml
    jinja2
    jupyter-core
    jupyterlab-pygments
    markupsafe
    mistune
    nbclient
    packaging
    pandocfilters
    pygments
    traitlets
  ]
  ++ bleach.optional-dependencies.css
  ++ lib.optionals (pythonOlder "3.10") [ importlib-metadata ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  nativeCheckInputs = [
    flaky
    ipykernel
    ipywidgets
    pytestCheckHook
  ];

  pytestFlags = [
    "-Wignore::DeprecationWarning"
  ];

  disabledTests = [
    # Attempts network access (Failed to establish a new connection: [Errno -3] Temporary failure in name resolution)
    "test_export"
    "test_webpdf_with_chromium"
    # ModuleNotFoundError: No module named 'nbconvert.tests'
    "test_convert_full_qualified_name"
    "test_post_processor"
  ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Converting Jupyter Notebooks";
    homepage = "https://github.com/jupyter/nbconvert";
    changelog = "https://github.com/jupyter/nbconvert/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.jupyter ];
  };
}
