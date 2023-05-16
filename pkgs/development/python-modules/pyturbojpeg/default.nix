{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, libjpeg_turbo
, numpy
, python
, substituteAll
}:

buildPythonPackage rec {
  pname = "pyturbojpeg";
<<<<<<< HEAD
  version = "1.7.2";
=======
  version = "1.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchPypi {
    pname = "PyTurboJPEG";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-ChFD05ZK0TCVvM+uqGzma2x5qqyD94uBvFpSnWuyL2c=";
=======
    hash = "sha256-9c7lfeM6PXF6CR3JtLi1NPmTwEbrv9Kh1kvdDQbskuI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    (substituteAll {
      src = ./lib-path.patch;
      libturbojpeg = "${libjpeg_turbo.out}/lib/libturbojpeg${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  propagatedBuildInputs = [
    numpy
  ];

  # upstream has no tests, but we want to test whether the library is found
  checkPhase = ''
    ${python.interpreter} -c 'from turbojpeg import TurboJPEG; TurboJPEG()'
  '';

  pythonImportsCheck = [
    "turbojpeg"
  ];

  meta = with lib; {
    description = "A Python wrapper of libjpeg-turbo for decoding and encoding JPEG image";
    homepage = "https://github.com/lilohuang/PyTurboJPEG";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
