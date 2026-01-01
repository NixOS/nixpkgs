{
  lib,
  fetchPypi,
  buildPythonPackage,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mergedict";
  version = "1.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4ZkrNqVCKQFPvLx6nIwo0fSuEx6h2NNFyTlz+fDcb9w=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mergedict" ];

<<<<<<< HEAD
  meta = {
    description = "Python dict with a merge() method";
    homepage = "https://github.com/schettino72/mergedict";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
=======
  meta = with lib; {
    description = "Python dict with a merge() method";
    homepage = "https://github.com/schettino72/mergedict";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
