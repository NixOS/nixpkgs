{ lib
, stdenv
, buildPythonPackage
, fetchPypi
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
<<<<<<< HEAD
  version = "1.0.0";
=======
  version = "0.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    inherit version;
    pname = lib.replaceStrings ["-"] ["_"] pname;
<<<<<<< HEAD
    hash = "sha256-9ILvYqEOaGMD84xm8I3xe53e5a2CIZwjVx7oDXar7qM=";
=======
    hash = "sha256-iMOE60MimXpY3ok46RrJ/5D2orbLKuI+IWnHQFrdOtg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

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
