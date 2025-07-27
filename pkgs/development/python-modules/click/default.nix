{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  importlib-metadata,
  pytestCheckHook,

  # large-rebuild downstream dependencies and applications
  flask,
  black,
  magic-wormhole,
  mitmproxy,
  typer,
  flit-core,
}:

buildPythonPackage rec {
  pname = "click";
  version = "8.2.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pallets";
    repo = "click";
    tag = version;
    hash = "sha256-cBvibVZKCppFJiRS8MNc3YT1JxmlXhRci7LHsrd4JGs=";
  };

  build-system = [ flit-core ];
  dependencies = lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # test fails with filename normalization on zfs
    "test_file_surrogates"

    # AssertionError: Unexpected pager output in test case
    # https://github.com/pallets/click/issues/2899
    "test_echo_via_pager"
  ];

  passthru.tests = {
    inherit
      black
      flask
      magic-wormhole
      mitmproxy
      typer
      ;
  };

  meta = with lib; {
    homepage = "https://click.palletsprojects.com/";
    description = "Create beautiful command line interfaces in Python";
    longDescription = ''
      A Python package for creating beautiful command line interfaces in a
      composable way, with as little code as necessary.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ nickcao ];
  };
}
