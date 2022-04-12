{ lib
, buildPythonPackage
, fetchPypi
, nibabel
, nilearn
, ipywidgets
, ipyvolume
, matplotlib
, numpy
, scipy
, scikit-learn
}:

buildPythonPackage rec {
  pname = "niwidgets";
  version = "0.2.2";
  src = fetchPypi {
    inherit pname version;
    sha256 = "Qq98crGNaNl4NcjAW1uFf8CzQTzUJ/26kSWzRsLSc2o=";
  };
  propagatedBuildInputs = [
    nibabel
    nilearn
    ipywidgets
    ipyvolume
    matplotlib
    numpy
    scipy
    scikit-learn
  ];
  postPatch = ''
    substituteInPlace setup.py --replace "nilearn>=0.5.2,<0.6.0" "nilearn"
    substituteInPlace setup.py --replace "scikit-learn>=0.20.3,<0.21.0" "scikit-learn"
    substituteInPlace setup.py --replace "nibabel>=2.4,<3.0" "nibabel"
  '';
  pythonImportsCheck = [ "niwidgets" ];
  meta = {
    description = "Interactive jupyter widgets for neuroimaging.";
    homepage = "https://github.com/nipy/niwidgets";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cfhammill ];
  };
}
