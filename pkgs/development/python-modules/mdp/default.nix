{
  lib,
  buildPythonPackage,
  fetchPypi,
  future,
  joblib,
  numpy,
  pytest,
  pythonOlder,
  scikit-learn,
}:

buildPythonPackage rec {
  pname = "mdp";
  version = "3.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "MDP";
    inherit version;
    hash = "sha256-rFKmUsy67RhX/xIJhi8Dv5sG0JOxJgb7QQeH2jqmWg4=";
  };

  postPatch = ''
    # https://github.com/mdp-toolkit/mdp-toolkit/issues/92
    substituteInPlace mdp/utils/routines.py \
      --replace numx.typeDict numx.sctypeDict
    substituteInPlace mdp/test/test_NormalizingRecursiveExpansionNode.py \
      --replace py.test"" "pytest"
    substituteInPlace mdp/test/test_RecursiveExpansionNode.py \
      --replace py.test"" "pytest"
  '';

  propagatedBuildInputs = [
    future
    numpy
  ];

  nativeCheckInputs = [
    joblib
    pytest
    scikit-learn
  ];

  pythonImportsCheck = [
    "mdp"
    "bimdp"
  ];

  checkPhase = ''
    runHook preCheck

    pytest --seed 7710873 mdp
    pytest --seed 7710873 bimdp

    runHook postCheck
  '';

  meta = with lib; {
    description = "Library for building complex data processing software by combining widely used machine learning algorithms";
    homepage = "https://mdp-toolkit.github.io/";
    changelog = "https://github.com/mdp-toolkit/mdp-toolkit/blob/MDP-${version}/CHANGES";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nico202 ];
  };
}
