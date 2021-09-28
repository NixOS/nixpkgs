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
  version = "2.0.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f963e90671fec51d1b248862a9bcc4639c1d6d3b1dbc1ee34d042cb765d8730a";
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
