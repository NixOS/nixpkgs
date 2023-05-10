{ lib
, buildPythonPackage
, fetchPypi
, numpy
, scipy
, tqdm
, scikit-learn
, nose
, numba
, torch
, unittestCheckHook
}:


buildPythonPackage rec {
  pname = "apricot-select";
  version = "0.6.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-O/hy1D7pavFByeTEDkNZqmyl4wIq5DsqiqRrJJR7i9g=";
  };

  propagatedBuildInputs = [
    numpy
    scipy
    tqdm
    numba
    torch
    scikit-learn
  ];

  postPatch = ''
    sed -i '/"nose"/d' setup.py
  '';

  pythonImportsCheck = [ "apricot" ];

  nativeCheckInputs = [
    nose
    unittestCheckHook
  ];

  meta = with lib; {
    description = "apricot implements submodular optimization for the purpose of selecting subsets of massive data sets to train machine learning models quickly.";
    homepage = "https://github.com/jmschrei/apricot";
    license = licenses.mit;
    maintainers = with maintainers; [ savyajha ];
  };
}
