{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytestCheckHook
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
, statsmodels
}:

buildPythonPackage rec {
  pname = "intensity-normalization";
  version = "2.2.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "intensity_normalization";
    inherit version;
    hash = "sha256-s/trDIRoqLFj3NO+iv3E+AEB4grBAHDlEL6+TCdsgmg=";
  };

  postPatch = ''
    substituteInPlace setup.cfg --replace "!=3.10.*," "" --replace "!=3.11.*" ""
    substituteInPlace setup.cfg --replace "pytest-runner" ""
  '';

  nativeBuildInputs = [ pythonRelaxDepsHook ];
  pythonRelaxDeps = [ "nibabel" ];

  propagatedBuildInputs = [
    matplotlib
    nibabel
    numpy
    pydicom
    pymedio
    scikit-fuzzy
    scikit-image
    scikit-learn
    scipy
    simpleitk
    statsmodels
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];
  pytestFlagsArray = [ "tests" ];

  pythonImportsCheck = [
    "intensity_normalization"
    "intensity_normalization.normalize"
    "intensity_normalization.plot"
    "intensity_normalization.util"
  ];


  meta = with lib; {
    homepage = "https://github.com/jcreinhold/intensity-normalization";
    description = "MRI intensity normalization tools";
    maintainers = with maintainers; [ bcdarwin ];
    license = licenses.asl20;
  };
}
