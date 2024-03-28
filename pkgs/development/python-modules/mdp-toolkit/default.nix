{ lib
, buildPythonPackage
, fetchgit
, future
, joblib
, numpy
, pytest
, pythonOlder
, scikit-learn
}:

buildPythonPackage rec {
  pname = "mdp-toolkit";
  version = "64f14eee8af55ecba32f884710d0e52ebbeb258b";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchgit {
    name = "mdp-toolkit";
    url = "https://github.com/mdp-toolkit/mdp-toolkit.git";
    rev = "64f14eee8af55ecba32f884710d0e52ebbeb258b";
    hash = "sha256-s6cPS6HM70tJUUAZMw6nhGyj64yNvQt+HilMENwdFHQ=";
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
    changelog = "https://github.com/mdp-toolkit/mdp-toolkit/blob/64f14eee8af55ecba32f884710d0e52ebbeb258b/CHANGES";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mq37 ];
  };
}
