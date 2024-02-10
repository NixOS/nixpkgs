{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, numpy
, astropy
, astropy-extension-helpers
, setuptools
, setuptools-scm
, pytestCheckHook
, pytest-doctestplus
, hypothesis
}:

buildPythonPackage rec {
  pname = "astropy-healpix";
  version = "1.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = lib.replaceStrings ["-"] ["_"] pname;
    hash = "sha256-BW+m7ZOWvtx3HTdNh3zeg9lGCj9ip4/gXb+boDlAMjo=";
  };

  nativeBuildInputs = [
    astropy-extension-helpers
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
