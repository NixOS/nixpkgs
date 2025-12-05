{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  attrs,
  click,
  click-default-group,
  networkx,
  optree,
  packaging,
  pluggy,
  rich,
  sqlalchemy,
  universal-pathlib,
  pytestCheckHook,
  cloudpickle,
  nbmake,
  pexpect,
  pytest-xdist,
  syrupy,
  git,
}:

buildPythonPackage rec {
  pname = "pytask";
  version = "0.5.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytask-dev";
    repo = "pytask";
    tag = "v${version}";
    hash = "sha256-qXqmI3IRJUTTsTdLlkjHc5+Vdct4j4MJYgnrRx3gTR8=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    attrs
    click
    click-default-group
    networkx
    optree
    packaging
    pluggy
    rich
    sqlalchemy
    universal-pathlib
  ];

  nativeCheckInputs = [
    pytestCheckHook
    cloudpickle
    git
    nbmake
    pexpect
    pytest-xdist
    syrupy
  ];

  # The test suite runs the installed command for e2e tests
  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';

  disabledTests = [
    # This accesses the network
    "test_download_file"
    # Racy
    "test_more_nested_pytree_and_python_node_as_return_with_names"
    # Without uv, subprocess unexpectedly doesn't fail
    "test_pytask_on_a_module_that_uses_the_functional_api"
    # Timeout
    "test_pdb_interaction_capturing_twice"
    "test_pdb_interaction_capturing_simple"
  ];

  meta = with lib; {
    description = "Workflow management system that facilitates reproducible data analyses";
    homepage = "https://github.com/pytask-dev/pytask";
    changelog = "https://github.com/pytask-dev/pytask/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ erooke ];
  };
}
