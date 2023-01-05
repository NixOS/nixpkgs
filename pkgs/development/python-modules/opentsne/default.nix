{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, setuptools-scm
, cython
, numpy
, scikit-learn
, scipy
, pytestCheckHook
, fetchurl
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

  pythonImportsCheck = [ "openTSNE" ];

  doCheck = true;

  checkInputs = [ pytestCheckHook ];

  preCheck = let
    macosko2015 = fetchurl {
      url = "https://file.biolab.si/opentsne/benchmark/macosko_2015.pkl.gz";
      hash = "sha256-WFhQwfdmtaNRR1olTj6EWlWceajoL/12WA+t1HzDrvA=";
    };
  in ''
    mkdir -p data
    ln -s ${macosko2015} data/macosko_2015.pkl.gz

    # ensure tests find installed package, not source dir
    mv openTSNE openTSNE.hidden
  '';

  disabledTests = lib.optionals (!stdenv.hostPlatform.isx86_64) [
    # overly precise comparison against reference
    # presumably calculated on x86
    "test_iris"
  ];

  meta = with lib; {
    description = "A modular Python implementation of t-Distributed Stochasitc Neighbor Embedding (t-SNE)";
    homepage = "https://opentsne.readthedocs.io";
    changelog = "https://github.com/pavlin-policar/openTSNE/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ totoroot ];
  };
}
