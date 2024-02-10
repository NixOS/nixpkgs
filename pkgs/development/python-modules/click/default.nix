{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, importlib-metadata
, pytestCheckHook

  # large-rebuild downstream dependencies and applications
, flask
, black
, magic-wormhole
, mitmproxy
, typer
}:

buildPythonPackage rec {
  pname = "click";
  version = "8.1.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pallets";
    repo = "click";
    rev = "refs/tags/${version}";
    hash = "sha256-8YqIKRyw5MegnRwAO7YTCZateEFQFTH2PHpE8gTPTow=";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # test fails with filename normalization on zfs
    "test_file_surrogates"
  ];

  passthru.tests = {
    inherit black flask magic-wormhole mitmproxy typer;
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
