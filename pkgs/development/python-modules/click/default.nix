{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,

  # large-rebuild downstream dependencies and applications
  flask,
  black,
  magic-wormhole,
  mitmproxy,
  typer,
}:

buildPythonPackage rec {
  pname = "click";
  version = "8.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pallets";
    repo = "click";
    tag = version;
    hash = "sha256-YjceWqNrMGu4ABVCZI+GLmXtptQfOiykbU4VK3x9j2A=";
  };

  build-system = [ flit-core ];

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

  meta = with lib; {
    changelog = "https://github.com/pallets/click/blob/${src.tag}/CHANGES.rst";
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
