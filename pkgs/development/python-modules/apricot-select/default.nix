{ lib
, buildPythonPackage
, fetchFromGitHub
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
  version = "0.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jmschrei";
    repo = "apricot";
    rev = "refs/tags/v${version}";
    hash = "sha256-1EQW44SWn8GBrIYl1yhzM5yNRjYKQKBa9eImp8kiXFg=";
  };

  propagatedBuildInputs = [
    numba
    numpy
    scikit-learn
    scipy
    tqdm
  ];

  nativeCheckInputs = [
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
