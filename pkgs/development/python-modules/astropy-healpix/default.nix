{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  numpy,
  astropy,
  extension-helpers,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  pytest-doctestplus,
  hypothesis,
}:

buildPythonPackage (finalAttrs: {
  pname = "astropy-healpix";
  version = "1.1.3";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "astropy_healpix";
    hash = "sha256-9SDYOr6CFdPo4aN7K9kRce42pvVfEQ1aLbhj112Bs7c=";
  };

  build-system = [
    extension-helpers
    numpy
    setuptools
    setuptools-scm
  ];

  dependencies = [
    numpy
    astropy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-doctestplus
    hypothesis
  ];

  disabledTests = lib.optional (!stdenv.hostPlatform.isDarwin) "test_interpolate_bilinear_skycoord";

  # tests must be run in the build directory
  preCheck = ''
    cd build/lib*
  '';

  meta = {
    description = "BSD-licensed HEALPix for Astropy";
    homepage = "https://github.com/astropy/astropy-healpix";
    changelog = "https://github.com/astropy/astropy-healpix/blob/v${finalAttrs.version}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.smaret ];
  };
})
