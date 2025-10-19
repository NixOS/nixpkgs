{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  networkx,
  pytestCheckHook,
  pytest-cov-stub,
  pydot,
}:

buildPythonPackage rec {
  pname = "phart";
  version = "1.1.4";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JpHjEVKpOPSNUdUjZxWBHt6AFCpci1nSRWhDXxG6nyw=";
  };

  pyproject = true;

  build-system = [
    hatchling
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  postPatch = ''
    # pythonRelaxDeps = true; didn't work
    substituteInPlace pyproject.toml \
      --replace-fail 'hatchling==1.26.3' 'hatchling'

    # This line makes the cli tool not work, removing it fixes it
    substituteInPlace src/phart/cli.py \
      --replace-fail "renderer.options.use_ascii = args.ascii" ""
  '';

  dependencies = [
    networkx
  ];

  disabledTestPaths = [
    # Many of the tests are stale
    "tests/test_cli.py"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pydot
  ];

  pythonImportsCheck = [
    "phart"
  ];

  meta = {
    description = "Python Hierarchical ASCII Representation Tool";
    homepage = "https://github.com/scottvr/phart";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ b-rodrigues ];
  };
}
