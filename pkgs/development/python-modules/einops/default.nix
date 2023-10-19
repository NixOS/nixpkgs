{ lib
, buildPythonPackage
, chainer
, fetchFromGitHub
, hatchling
, nbconvert
, numpy
, parameterized
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "einops";
  version = "0.6.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "arogozhnikov";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-/bnp8IhDxp8EB/PoW5Dz+7rOru0/odOrts84aq4qyJw=";
  };

  nativeBuildInputs = [ hatchling ];

  nativeCheckInputs = [
    chainer
    nbconvert
    numpy
    parameterized
    pytestCheckHook
  ];

  # No CUDA in sandbox
  EINOPS_SKIP_CUPY = 1;

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  pythonImportsCheck = [
    "einops"
  ];

  disabledTests = [
    # Tests are failing as mxnet is not pulled-in
    # https://github.com/NixOS/nixpkgs/issues/174872
    "test_all_notebooks"
    "test_dl_notebook_with_all_backends"
    "test_backends_installed"
  ];

  disabledTestPaths = [
    "tests/test_layers.py"
  ];

  meta = with lib; {
    description = "Flexible and powerful tensor operations for readable and reliable code";
    homepage = "https://github.com/arogozhnikov/einops";
    license = licenses.mit;
    maintainers = with maintainers; [ yl3dy ];
  };
}

