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
  version = "2.1.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-92STD5sOc9TLf3Ooaoi3afWkXiGjVgUUFvSVTeP8MaA=";
  };

  postPatch = ''
    substituteInPlace setup.cfg --replace "pytest-runner" ""
  '';

  checkInputs = [ pytestCheckHook ];
  pythonImportsCheck = [
    "intensity_normalization"
    "intensity_normalization.normalize"
    "intensity_normalization.plot"
    "intensity_normalization.util"
  ];
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

  meta = with lib; {
    homepage = "https://github.com/jcreinhold/intensity-normalization";
    description = "MRI intensity normalization tools";
    maintainers = with maintainers; [ bcdarwin ];
    license = licenses.asl20;
  };
}
