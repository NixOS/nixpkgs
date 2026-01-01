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
  version = "1.0.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "igraph";
    repo = "python-igraph";
    tag = version;
    postFetch = ''
      # export-subst prevents reproducability
      rm $out/.git_archival.json
    '';
    hash = "sha256-Y7ZQ1yNoD8A5b6c92OGz9Unietdg1uNt/Za6nxdCSP0=";
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
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;
=======
  ++ lib.flatten (lib.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  disabledTests = [
    "testAuthorityScore"
    "test_labels"
  ];

  pythonImportsCheck = [ "igraph" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "High performance graph data structures and algorithms";
    mainProgram = "igraph";
    homepage = "https://igraph.org/python/";
    changelog = "https://github.com/igraph/python-igraph/blob/${src.rev}/CHANGELOG.md";
<<<<<<< HEAD
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
=======
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      MostAwesomeDude
      dotlambda
    ];
  };
}
