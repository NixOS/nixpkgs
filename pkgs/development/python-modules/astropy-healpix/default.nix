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

buildPythonPackage rec {
  pname = "astropy-healpix";
  version = "1.1.2";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = lib.replaceStrings [ "-" ] [ "_" ] pname;
    hash = "sha256-A2cd8So27Ds1fCRNUVS2eGNi/12AdwZ1x7JIFRAQZuQ=";
  };

  nativeBuildInputs = [
    extension-helpers
    numpy
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
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

  meta = with lib; {
    description = "BSD-licensed HEALPix for Astropy";
    homepage = "https://github.com/astropy/astropy-healpix";
    license = licenses.bsd3;
    maintainers = [ maintainers.smaret ];
  };
}
