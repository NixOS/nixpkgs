{ stdenv
, buildPythonPackage
, fetchFromGitHub
, isPy27
, pytestCheckHook
, scipy
, numpy
, scikitlearn
, pandas
, matplotlib
, joblib
}:

buildPythonPackage rec {
  pname = "mlxtend";
  version = "0.17.3";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "rasbt";
    repo = pname;
    rev = version;
    sha256 = "1515wgmj5rhwpmky7apmmvys1630sfg534fai6559s13hp11pdcl";
  };

  checkInputs = [ pytestCheckHook ];
  # image tests download files over the network
  pytestFlagsArray = [ "-sv" "--ignore=mlxtend/image" ];
  # Fixed in master, but failing in release version
  # see: https://github.com/rasbt/mlxtend/pull/721
  disabledTests = [ "test_variance_explained_ratio" ];

  propagatedBuildInputs = [
    scipy
    numpy
    scikitlearn
    pandas
    matplotlib
    joblib
  ];

  meta = with stdenv.lib; {
    description = "A library of Python tools and extensions for data science";
    homepage = "https://github.com/rasbt/mlxtend";
    license= licenses.bsd3;
    maintainers = with maintainers; [ evax ];
    platforms = platforms.unix;
  };
}
