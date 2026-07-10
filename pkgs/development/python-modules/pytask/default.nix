{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  click,
  click-default-group,
  cloudpickle,
  git,
  msgspec,
  nbmake,
  networkx,
  optree,
  packaging,
  pexpect,
  pluggy,
  pytest-xdist,
  pytestCheckHook,
  rich,
  sqlalchemy,
  syrupy,
  universal-pathlib,
}:

buildPythonPackage rec {
  pname = "pytask";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytask-dev";
    repo = "pytask";
    tag = "v${version}";
    hash = "sha256-l7jQAUBb8iW5S8Am2cMCgqYcvtLq8UgEhrCNnSx9N1E=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    click
    click-default-group
    msgspec
    optree
    packaging
    pluggy
    rich
    sqlalchemy
    universal-pathlib
  ]
  ++ msgspec.optional-dependencies.toml;

  optional-dependencies = {
    dag = [ networkx ];
  };

  nativeCheckInputs = [
    cloudpickle
    git
    nbmake
    pexpect
    pytest-xdist
    pytestCheckHook
    syrupy
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pytestFlags = [ "--snapshot-warn-unused" ];

  # The test suite runs the installed command for e2e tests
  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';

  disabledTests = [
    # This accesses the network
    "test_download_file"
    # Racy
    "test_more_nested_pytree_and_python_node_as_return_with_names"
    # Timeout
    "test_pdb_interaction_capturing_twice"
    "test_pdb_interaction_capturing_simple"
  ];

  pythonImportsCheck = [ "pytask" ];

  meta = {
    description = "Workflow management system that facilitates reproducible data analyses";
    homepage = "https://github.com/pytask-dev/pytask";
    changelog = "https://github.com/pytask-dev/pytask/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ erooke ];
  };
}
