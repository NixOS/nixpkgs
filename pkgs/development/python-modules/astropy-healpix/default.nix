{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, fetchpatch
, numpy
, astropy
, astropy-extension-helpers
, setuptools-scm
, pytestCheckHook
, pytest-doctestplus
, hypothesis
}:

buildPythonPackage rec {
  pname = "astropy-healpix";
  version = "1.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = lib.replaceStrings ["-"] ["_"] pname;
    hash = "sha256-9ILvYqEOaGMD84xm8I3xe53e5a2CIZwjVx7oDXar7qM=";
  };

  patches = [
    # remove on next udpate. make Numpy loop function args const correct.
    # https://github.com/astropy/astropy-healpix/pull/199
    (fetchpatch {
      name = "numpy-const-args-match.patch";
      url = "https://github.com/astropy/astropy-healpix/commit/ccf6d9ea4be131f56646adbd7bc482bfcd84f21c.patch";
      hash = "sha256-fpDxTbs3sHJSb4mnveorM+wlseXbZu1biGyBTNC9ZUo=";
    })
  ];

  nativeBuildInputs = [
    astropy-extension-helpers
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
