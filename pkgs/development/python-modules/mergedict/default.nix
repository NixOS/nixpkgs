{ lib
, fetchPypi
, buildPythonPackage
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "mergedict";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4ZkrNqVCKQFPvLx6nIwo0fSuEx6h2NNFyTlz+fDcb9w=";
  };

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mergedict" ];

  meta = with lib; {
    description = "A Python dict with a merge() method";
    homepage = "https://github.com/schettino72/mergedict";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
