{ buildPythonPackage
, cloudpickle
, deepdish
, deepmerge
, dm-haiku
, fetchFromGitHub
, jaxlib
, lib
, poetry
, pytestCheckHook
, pytorch
, pyyaml
, sh
, tables
, tabulate
, tensorboardx
, tensorflow
, toolz
, treex
, typing-extensions
}:

buildPythonPackage rec {
  pname = "elegy";
  version = "0.8.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "poets-ai";
    repo = pname;
    rev = version;
    sha256 = "sha256-2qBHiNmdO53rD9/tudnf1z4+6a5ZHH/y2wB4v3/Tqdg=";
  };

  nativeBuildInputs = [
    poetry
  ];

  buildInputs = [ jaxlib ];

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
    pytorch
    sh
    tensorflow
  ];

  disabledTests = [
    # Fails with `Could not find compiler for platform Host: NOT_FOUND: could not find registered compiler for platform Host -- check target linkage`.
    # Runs fine in docker with Ubuntu 22.04. I suspect the issue is the sandboxing in `nixpkgs` but not sure.
    "test_saved_model_poly"
  ];

  meta = with lib; {
    description = "Neural Networks framework based on Jax inspired by Keras and Haiku";
    homepage = "https://github.com/poets-ai/elegy";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}
