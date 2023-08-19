{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
, numba
, numpy
, pytestCheckHook
, pythonOlder
, scikit-learn
, scipy
, tqdm
}:

buildPythonPackage rec {
  pname = "apricot-select";
  version = "0.6.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jmschrei";
    repo = "apricot";
    # https://github.com/jmschrei/apricot/issues/38
    rev = "7389a81cfa56a1abff17ffea64c244818c943df4";
    hash = "sha256-ChfYDlGW7OrLVuVxp/n09zCzSEP9F4/UyOJnh5nIGvk=";
  };

  propagatedBuildInputs = [
    numba
    numpy
    scikit-learn
    scipy
    tqdm
  ];

  nativeCheckInputs = [
    nose
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "apricot"
  ];

  meta = with lib; {
    description = "Module that implements submodular optimization for the purpose of selecting subsets of massive data sets";
    homepage = "https://github.com/jmschrei/apricot";
    changelog = "https://github.com/jmschrei/apricot/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
