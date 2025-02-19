{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  importlib-metadata,
  pytestCheckHook,
  flit-core,
  colorama,

  # large-rebuild downstream dependencies and applications
  flask,
  black,
  magic-wormhole,
  mitmproxy,
  typer,
}:

buildPythonPackage rec {
  pname = "click";
  version = "8.1.8";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pallets";
    repo = "click";
    tag = version;
    hash = "sha256-pAAqf8jZbDfVZUoltwIFpov/1ys6HSYMyw3WV2qcE/M=";
  };

  build-system = [ flit-core ];

  propagatedBuildInputs = [ colorama ] ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # test fails with filename normalization on zfs
    "test_file_surrogates"
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

  pythonImportsCheck = [
    "click"
  ];

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
