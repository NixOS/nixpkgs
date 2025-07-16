{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  pytestCheckHook,
  less,

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
  version = "8.2.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "pallets";
    repo = "click";
    tag = version;
    hash = "sha256-3FfLKwpfkiGfY2+H2fQoZwLBqfPlV46xw2Bc4YEsyps=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [
    pytestCheckHook
    less
  ];

  disabledTests = [
    # test fails with filename normalization on zfs
    "test_file_surrogates"
    # for some reason the tests fail to execute cat, even though they run with less just fine,
    # even adding coreutils to nativeCheckInputs explicitly does not change anything
    "test_echo_via_pager[test0-cat]"
    "test_echo_via_pager[test0-cat ]"
    "test_echo_via_pager[test0- cat ]"
    "test_echo_via_pager[test1-cat]"
    "test_echo_via_pager[test1-cat ]"
    "test_echo_via_pager[test1- cat ]"
    "test_echo_via_pager[test2-cat]"
    "test_echo_via_pager[test2-cat ]"
    "test_echo_via_pager[test2- cat ]"
    "test_echo_via_pager[test3-cat]"
    "test_echo_via_pager[test3-cat ]"
    "test_echo_via_pager[test3- cat ]"
    "test_echo_via_pager[test4-cat]"
    "test_echo_via_pager[test4-cat ]"
    "test_echo_via_pager[test4- cat ]"
    "test_echo_via_pager[test5-cat]"
    "test_echo_via_pager[test5-cat ]"
    "test_echo_via_pager[test5- cat ]"
    "test_echo_via_pager[test6-cat]"
    "test_echo_via_pager[test6-cat ]"
    "test_echo_via_pager[test6- cat ]"
    "test_echo_via_pager[test7-cat]"
    "test_echo_via_pager[test7-cat ]"
    "test_echo_via_pager[test7- cat ]"
    "test_echo_via_pager[test8-cat]"
    "test_echo_via_pager[test8-cat ]"
    "test_echo_via_pager[test8- cat ]"
    "test_echo_via_pager[test9-cat]"
    "test_echo_via_pager[test9-cat ]"
    "test_echo_via_pager[test9- cat ]"
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
