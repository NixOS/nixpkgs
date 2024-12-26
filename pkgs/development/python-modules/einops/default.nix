{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  hatchling,
  jupyter,
  nbconvert,
  numpy,
  parameterized,
  pillow,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "einops";
  version = "0.8.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "arogozhnikov";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-6x9AttvSvgYrHaS5ESKOwyEnXxD2BitYTGtqqSKur+0=";
  };

  patches = [
    # https://github.com/arogozhnikov/einops/pull/325
    (fetchpatch2 {
      name = "numpy_2-compatibility.patch";
      url = "https://github.com/arogozhnikov/einops/commit/11680b457ce2216d9827330d0b794565946847d7.patch";
      hash = "sha256-OKWp319ClYarNrek7TdRHt+NKTOEfBdJaV0U/6vLeMc=";
    })
  ];

  nativeBuildInputs = [ hatchling ];

  nativeCheckInputs = [
    jupyter
    nbconvert
    numpy
    parameterized
    pillow
    pytestCheckHook
  ];

  env.EINOPS_TEST_BACKENDS = "numpy";

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  pythonImportsCheck = [ "einops" ];

  disabledTests = [
    # Tests are failing as mxnet is not pulled-in
    # https://github.com/NixOS/nixpkgs/issues/174872
    "test_all_notebooks"
    "test_dl_notebook_with_all_backends"
    "test_backends_installed"
  ];

  disabledTestPaths = [ "tests/test_layers.py" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Flexible and powerful tensor operations for readable and reliable code";
    homepage = "https://github.com/arogozhnikov/einops";
    license = licenses.mit;
    maintainers = with maintainers; [ yl3dy ];
  };
}
