{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytestCheckHook
, matplotlib
, nibabel
, numpy
, scikit-fuzzy
, scikitimage
, scikit-learn
, scipy
, statsmodels
}:

buildPythonPackage rec {
  pname = "intensity-normalization";
  version = "2.2.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "intensity_normalization";
    inherit version;
    sha256 = "sha256-Yjd4hXmbT87xNKSqc6zkKNisOVhQzQAUZI5wBiI/UBk=";
  };

  propagatedBuildInputs = [
    matplotlib
    nibabel
    numpy
    scikit-fuzzy
    scikitimage
    scikit-learn
    scipy
    statsmodels
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "pytest-runner" ""
  '';

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
    # depends on simpleitk python wrapper which is not packaged yet
    broken = true;
  };
}
