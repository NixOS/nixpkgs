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
  version = "2.1.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e7b46039311bcbba40224d85eb07eefe1488bd8a6faa893a180e15e65c48b7f5";
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
