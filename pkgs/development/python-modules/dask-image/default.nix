{ lib
, stdenv
, buildPythonPackage
, dask
, fetchPypi
, numpy
, pims
, pytestCheckHook
, pythonOlder
<<<<<<< HEAD
, scikit-image
=======
, scikitimage
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, scipy
}:

buildPythonPackage rec {
  pname = "dask-image";
<<<<<<< HEAD
  version = "2023.8.1";
=======
  version = "2022.9.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-XpqJhbBSehtZQsan50Tg5X0mTiIscFjwW664HDdNBLY=";
=======
    hash = "sha256-8SPf0Wp9FcdmYqasFHeFCe1e7ZtJT0Mi5ZRemxWSNUc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    dask
    numpy
    scipy
    pims
  ];

  nativeCheckInputs = [
    pytestCheckHook
<<<<<<< HEAD
    scikit-image
=======
    scikitimage
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--flake8" ""
  '';

  pythonImportsCheck = [
    "dask_image"
  ];

  meta = with lib; {
<<<<<<< HEAD
    description = "Distributed image processing";
    homepage = "https://github.com/dask/dask-image";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ ];
=======
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "Distributed image processing";
    homepage = "https://github.com/dask/dask-image";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
