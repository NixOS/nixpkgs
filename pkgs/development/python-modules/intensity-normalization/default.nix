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
  version = "2.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "intensity_normalization";
    inherit version;
    sha256 = "sha256-0tc21NBj3Cajklk9mWbKfBzbSwjUrBWs/SlakjEHC1U=";
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

  checkInputs = [
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
  };
}
