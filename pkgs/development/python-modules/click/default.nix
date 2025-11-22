{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
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
  version = "8.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pallets";
    repo = "click";
    tag = version;
    hash = "sha256-3FfLKwpfkiGfY2+H2fQoZwLBqfPlV46xw2Bc4YEsyps=";
  };

  patches = [
    # https://github.com/pallets/click/pull/2940
    (fetchpatch {
      name = "fix-SystemExit-when-using-stdin.patch";
      url = "https://github.com/pallets/click/commit/93c6966eb3a575c2b600434d1cc9f4b3aee505ac.patch";
      hash = "sha256-DkVF0JnKbcsdAhgVjWJEDZZ8vr2sf6wba8P3SyRUy6o=";
    })
  ];

  build-system = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # for some reason the tests fail to execute cat, even though they run with less just fine,
    # even adding coreutils to nativeCheckInputs explicitly does not change anything
    "test_echo_via_pager"
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

  meta = {
    changelog = "https://github.com/pallets/click/blob/${src.tag}/CHANGES.rst";
    homepage = "https://click.palletsprojects.com/";
    description = "Create beautiful command line interfaces in Python";
    longDescription = ''
      A Python package for creating beautiful command line interfaces in a
      composable way, with as little code as necessary.
    '';
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
