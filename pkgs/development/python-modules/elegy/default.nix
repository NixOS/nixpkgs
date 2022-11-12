{ lib
, buildPythonPackage
, cloudpickle
, deepdish
, deepmerge
, dm-haiku
, fetchFromGitHub
, jaxlib
, poetry
, pytestCheckHook
, pythonOlder
, pyyaml
, sh
, tables
, tabulate
, tensorboardx
, tensorflow
, toolz
, torch
, treex
, typing-extensions
}:

buildPythonPackage rec {
  pname = "elegy";
  version = "0.8.6";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "poets-ai";
    repo = pname;
    rev = version;
    hash = "sha256-FZmLriYhsX+zyQKCtCjbOy6MH+AvjzHRNUyaDSXGlLI=";
  };

  # The cloudpickle constraint is too strict. wandb is marked as an optional
  # dependency but `buildPythonPackage` doesn't seem to respect that setting.
  # Python constraint: https://github.com/poets-ai/elegy/issues/244
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'python = ">=3.7,<3.10"' 'python = ">=3.7"' \
      --replace 'cloudpickle = "^1.5.0"' 'cloudpickle = "*"' \
      --replace 'wandb = { version = "^0.12.10", optional = true }' ""
  '';

  nativeBuildInputs = [
    poetry
  ];

  buildInputs = [
    jaxlib
  ];

  propagatedBuildInputs = [
    cloudpickle
    deepdish
    deepmerge
    dm-haiku
    pyyaml
    tables
    tabulate
    tensorboardx
    toolz
    treex
    typing-extensions
  ];

  pythonImportsCheck = [
    "elegy"
  ];

  checkInputs = [
    pytestCheckHook
    torch
    sh
    tensorflow
  ];

  disabledTests = [
    # Fails with `Could not find compiler for platform Host: NOT_FOUND: could not find registered compiler for platform Host -- check target linkage`.
    # Runs fine in docker with Ubuntu 22.04. I suspect the issue is the sandboxing in `nixpkgs` but not sure.
    "test_saved_model_poly"
    # AttributeError: module 'jax' has no attribute 'tree_multimap'
    "DataLoaderTestCase"
  ];

  meta = with lib; {
    description = "Neural Networks framework based on Jax inspired by Keras and Haiku";
    homepage = "https://github.com/poets-ai/elegy";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}
