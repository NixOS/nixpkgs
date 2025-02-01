{
  lib,
  buildPythonPackage,
  pythonOlder,
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
  nbmake,
  pexpect,
  pytest-xdist,
  syrupy,
  git,
  tomli,
}:
buildPythonPackage rec {
  pname = "pytask";
  version = "0.5.2";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pytask-dev";
    repo = "pytask";
    tag = "v${version}";
    hash = "sha256-YJouWQ9Edj27nD72m7EDSH9TXcrsu6X+pGDo5fgGU5U=";
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
  ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  nativeCheckInputs = [
    pytestCheckHook
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
  ];

  meta = with lib; {
    description = "Workflow management system that facilitates reproducible data analyses";
    homepage = "https://github.com/pytask-dev/pytask";
    changelog = "https://github.com/pytask-dev/pytask/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ erooke ];
  };
}
