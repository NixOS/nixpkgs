{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, setuptools-scm
, cython
, numpy
, scikit-learn
, scipy
}:

buildPythonPackage rec {
  pname = "opentsne";
  version = "0.6.2";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pavlin-policar";
    repo = "openTSNE";
    rev = "refs/tags/v${version}";
    hash = "sha256-OFMk6q63tuSmhG/jeGakL1CYEKTj+829BMOa6pd/JEM=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    cython
    numpy
    scikit-learn
    scipy
  ];

  # No such file or directory: 'data/macosko_2015.pkl.gz'
  doCheck = false;

  pythonImportsCheck = [ "openTSNE" ];

  meta = with lib; {
    description = "A modular Python implementation of t-Distributed Stochasitc Neighbor Embedding (t-SNE)";
    homepage = "https://opentsne.readthedocs.io";
    changelog = "https://github.com/pavlin-policar/openTSNE/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ totoroot ];
  };
}
