{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  setuptools,
  numpy,
  scipy,
  h5py,
  truncnorm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "bayespy";
  version = "0.6.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bayespy";
    repo = "bayespy";
    tag = version;
    hash = "sha256-gxvfUaRFZASZCWcwuM57J3opKKlhaBW8u3uPl08/lXw=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://salsa.debian.org/python-team/packages/python-bayespy/-/raw/071f54815608b31aebac8f8e83bc532b2c632a48/debian/patches/numpy2.4-compat.patch";
      hash = "sha256-Tk3z94+vbGaSIqGFFRQZz0pcXI1Fzcbnva3oWnv502U=";
    })
  ];

  postPatch = ''
    sed -i setup.cfg \
      -e '/tag_build =/d' \
      -e '/tag_date =/d'
  '';

  build-system = [ setuptools ];

  dependencies = [
    numpy
    scipy
    h5py
    truncnorm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "bayespy" ];

  meta = {
    homepage = "http://www.bayespy.org";
    description = "Variational Bayesian inference tools for Python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jluttine ];
  };
}
