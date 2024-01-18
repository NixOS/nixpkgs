{ lib
, buildPythonPackage
, fetchFromGitHub
, numba
, numpy
, pillow
, scipy
, pytestCheckHook
,
}:
buildPythonPackage rec {
  pname = "pymatting";
  version = "1.1.10";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pymatting";
    repo = "pymatting";
    rev = "refs/tags/v${version}";
    hash = "sha256-wHCTqcBvVN/pTXH3iW57DPpMEsnehutRQB5NaugS6Zs=";
  };

  patches = [ ./01-kdtree-signature.patch ];

  propagatedBuildInputs = [
    numba
    numpy
    pillow
    scipy
  ];

  pythonImportsCheck = [ "pymatting" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # no access to input data set
    # see: https://github.com/pymatting/pymatting/blob/master/tests/download_images.py
    "test_alpha"
    "test_laplacians"
    "test_preconditioners"
    "test_lkm"
  ];

  meta = with lib; {
    description = "A Python library for alpha matting";
    homepage = "https://github.com/pymatting/pymatting";
    changelog = "https://github.com/pymatting/pymatting/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ blaggacao ];
  };
}

