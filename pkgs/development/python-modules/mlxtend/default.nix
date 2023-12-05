{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, pytestCheckHook
, scipy
, numpy
, scikit-learn
, pandas
, matplotlib
, joblib
}:

buildPythonPackage rec {
  pname = "mlxtend";
  version = "0.22.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "rasbt";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-YLCNLpg2qrdFon0/gdggJd9XovHwRHAdleBFQc18qzE=";
  };

  nativeCheckInputs = [ pytestCheckHook ];
  # image tests download files over the network
  pytestFlagsArray = [ "-sv" "--ignore=mlxtend/image" ];
  # Fixed in master, but failing in release version
  # see: https://github.com/rasbt/mlxtend/pull/721
  disabledTests = [ "test_variance_explained_ratio" ];

  propagatedBuildInputs = [
    scipy
    numpy
    scikit-learn
    pandas
    matplotlib
    joblib
  ];

  meta = with lib; {
    description = "A library of Python tools and extensions for data science";
    homepage = "https://github.com/rasbt/mlxtend";
    license= licenses.bsd3;
    maintainers = with maintainers; [ evax ];
    platforms = platforms.unix;
    # incompatible with nixpkgs scikit-learn version
    broken = true;
  };
}
