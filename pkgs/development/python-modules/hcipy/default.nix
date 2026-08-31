{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  numpy,
  scipy,
  matplotlib,
  pillow,
  pyyaml,
  astropy,
  imageio,
  xxhash,
  numexpr,
  asdf,

  # tests
  pytest-cov-stub,
  pytestCheckHook,
  mpmath,
  dill,
}:

buildPythonPackage rec {
  pname = "hcipy";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Kt2T6EgCrPTJGiygjmFUh1HH1DthFcZ2mMlnlu0HxsE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    numpy
    scipy
    matplotlib
    pillow
    pyyaml
    astropy
    imageio
    xxhash
    numexpr
    asdf
  ];

  pythonImportsCheck = [ "hcipy" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    mpmath
    dill
  ];

  meta = {
    description = "Framework for performing optical propagation simulations, meant for high contrast imaging";
    changelog = "https://github.com/ehpor/hcipy/blob/master/doc/changelog.rst";
    homepage = "https://hcipy.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ BarrOff ];
    # seems to be broken on arm, see: https://github.com/NixOS/nixpkgs/pull/341906
    broken = stdenv.isAarch64;
  };
}
