{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  hatchling,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "expandvars";
  version = "1.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mK3YJot2Df7kV73hwXv3RXlf3rwit92rdf0yeGU/HgU=";
  };

  nativeBuildInputs = [ hatchling ];

  pythonImportsCheck = [ "expandvars" ];

  nativeCheckInputs = [ pytestCheckHook ];

<<<<<<< HEAD
  meta = {
    description = "Expand system variables Unix style";
    homepage = "https://github.com/sayanarijit/expandvars";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Expand system variables Unix style";
    homepage = "https://github.com/sayanarijit/expandvars";
    license = licenses.mit;
    maintainers = with maintainers; [ geluk ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
