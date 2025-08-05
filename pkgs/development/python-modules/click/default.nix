{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
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

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "pallets";
    repo = "click";
    tag = version;
    hash = "sha256-cBvibVZKCppFJiRS8MNc3YT1JxmlXhRci7LHsrd4JGs=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # for some reason the tests fail to execute cat, even though they run with less just fine,
    # even adding coreutils to nativeCheckInputs explicitly does not change anything
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
