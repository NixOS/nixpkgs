{ lib
, buildPythonPackage
, cython
, fetchPypi
, mock
, numpy
, scipy
, smart-open
, testfixtures
, pyemd
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "gensim";
  version = "4.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-i18RwOalMICGtI6PaEEiOk+ho31RNoRhK37oVLUzAV8=";
  };

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    smart-open
    numpy
    scipy
  ];

  nativeCheckInputs = [
    mock
    pyemd
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "gensim"
  ];

  # Test setup takes several minutes
  doCheck = false;

  pytestFlagsArray = [
    "gensim/test"
  ];

  meta = with lib; {
    description = "Topic-modelling library";
    homepage = "https://radimrehurek.com/gensim/";
    changelog = "https://github.com/RaRe-Technologies/gensim/blob/${version}/CHANGELOG.md";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ jyp ];
  };
}
