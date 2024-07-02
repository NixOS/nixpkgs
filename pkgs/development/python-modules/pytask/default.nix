{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, hatchling
, hatch-vcs
, attrs
, click
, click-default-group
, networkx
, optree
, packaging
, pluggy
, rich
, sqlalchemy
, universal-pathlib
, pytestCheckHook
, deepdiff
, nbmake
, pexpect
, pytest-cov
, pytest-xdist
, syrupy
, aiohttp
, git
}:
buildPythonPackage rec {
  pname = "pytask";
  version = "0.5.0";
  format = "pyproject";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pytask-dev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-uU16hMXTa0nTQF7lt6A2kjkuHFHCqEdvTmEs61OZUho=";
  };

  patches = [
    # Remove test which depends on non-free package
    ./0001-tests-make-coiled-an-optional-import.patch
    # Make test run with src as its root directory
    ./0002-tests-remove-dependence-on-parent-folder-name.patch
  ];

  nativeBuildInputs = [
    hatchling
    hatch-vcs
  ];

  propagatedBuildInputs = [
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
    git
    deepdiff
    nbmake
    pexpect
    pytest-cov
    pytest-xdist
    syrupy
    aiohttp
  ];

  # The test suite runs the installed command for e2e tests
  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';

  disabledTests = [
    # This accesses the network
    "test_download_file"
  ];

  meta = with lib; {
    description = "Workflow management system that facilitates reproducible data analyses";
    homepage = "https://github.com/pytask-dev/pytask";
    license = licenses.mit;
    maintainers = with maintainers; [ erooke ];
  };
}
