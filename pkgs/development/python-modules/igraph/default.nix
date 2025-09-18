{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pkg-config,
  cmake,
  setuptools,
  igraph,
  texttable,
  cairocffi,
  matplotlib,
  plotly,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "igraph";
  version = "0.11.9";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "igraph";
    repo = "python-igraph";
    tag = version;
    postFetch = ''
      # export-subst prevents reproducability
      rm $out/.git_archival.json
    '';
    hash = "sha256-rmIICiIyEr5JCmkDAzcdisVaaKDraTQEquPHjK4d7oU=";
  };

  postPatch = ''
    rm -r vendor
  '';

  nativeBuildInputs = [ pkg-config ];

  build-system = [
    cmake
    setuptools
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [ igraph ];

  dependencies = [ texttable ];

  optional-dependencies = {
    cairo = [ cairocffi ];
    matplotlib = [ matplotlib ];
    plotly = [ plotly ];
    plotting = [ cairocffi ];
  };

  # NB: We want to use our igraph, not vendored igraph, but even with
  # pkg-config on the PATH, their custom setup.py still needs to be explicitly
  # told to do it. ~ C.
  env.IGRAPH_USE_PKG_CONFIG = true;

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

  disabledTests = [
    "testAuthorityScore"
    "test_labels"
  ];

  pythonImportsCheck = [ "igraph" ];

  meta = with lib; {
    description = "High performance graph data structures and algorithms";
    mainProgram = "igraph";
    homepage = "https://igraph.org/python/";
    changelog = "https://github.com/igraph/python-igraph/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      MostAwesomeDude
      dotlambda
    ];
  };
}
