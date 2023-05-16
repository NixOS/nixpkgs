{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytestCheckHook
<<<<<<< HEAD
, pythonRelaxDepsHook
, matplotlib
, nibabel
, numpy
, pydicom
, pymedio
, scikit-fuzzy
, scikit-image
, scikit-learn
, scipy
, simpleitk
=======
, matplotlib
, nibabel
, numpy
, scikit-fuzzy
, scikitimage
, scikit-learn
, scipy
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, statsmodels
}:

buildPythonPackage rec {
  pname = "intensity-normalization";
<<<<<<< HEAD
  version = "2.2.4";
=======
  version = "2.2.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "intensity_normalization";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-s/trDIRoqLFj3NO+iv3E+AEB4grBAHDlEL6+TCdsgmg=";
  };

  postPatch = ''
    substituteInPlace setup.cfg --replace "!=3.10.*," "" --replace "!=3.11.*" ""
    substituteInPlace setup.cfg --replace "pytest-runner" ""
  '';

  nativeBuildInputs = [ pythonRelaxDepsHook ];
  pythonRelaxDeps = [ "nibabel" ];

=======
    hash = "sha256-Yjd4hXmbT87xNKSqc6zkKNisOVhQzQAUZI5wBiI/UBk=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    matplotlib
    nibabel
    numpy
<<<<<<< HEAD
    pydicom
    pymedio
    scikit-fuzzy
    scikit-image
    scikit-learn
    scipy
    simpleitk
=======
    scikit-fuzzy
    scikitimage
    scikit-learn
    scipy
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    statsmodels
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];
<<<<<<< HEAD
  pytestFlagsArray = [ "tests" ];
=======

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "pytest-runner" ""
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  pythonImportsCheck = [
    "intensity_normalization"
    "intensity_normalization.normalize"
    "intensity_normalization.plot"
    "intensity_normalization.util"
  ];

<<<<<<< HEAD

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    homepage = "https://github.com/jcreinhold/intensity-normalization";
    description = "MRI intensity normalization tools";
    maintainers = with maintainers; [ bcdarwin ];
    license = licenses.asl20;
<<<<<<< HEAD
=======
    # depends on simpleitk python wrapper which is not packaged yet
    broken = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
