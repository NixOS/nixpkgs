{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  pytestCheckHook,
  matplotlib,
  nibabel,
  numpy,
  pydicom,
  pymedio,
  scikit-fuzzy,
  scikit-image,
  scikit-learn,
  scipy,
  simpleitk,
  statsmodels,
}:

buildPythonPackage rec {
  pname = "intensity-normalization";
  version = "3.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "intensity_normalization";
    inherit version;
    hash = "sha256-d5f+Ug/ta9RQjk3JwHmVJQr8g93glzf7IcmLxLeA1tQ=";
  };

  postPatch = ''
    substituteInPlace setup.cfg --replace "!=3.10.*," "" --replace "!=3.11.*" ""
    substituteInPlace setup.cfg --replace "pytest-runner" ""
  '';

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

  nativeCheckInputs = [ pytestCheckHook ];
  enabledTestPaths = [ "tests" ];

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
