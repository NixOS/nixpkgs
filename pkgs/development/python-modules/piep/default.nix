{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pygments,
  pytestCheckHook,
}:

buildPythonPackage rec {
  version = "0.10.0";
  pname = "piep";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aM7KQJZr1P0Hs2ReyRj2ItGUo+fRJ+TU3lLAU2Mu8KA=";
  };

  build-system = [ setuptools ];

  dependencies = [ pygments ];

  pythonImportsCheck = [ "piep" ];

  nativeCheckInputs = [ pytestCheckHook ];

<<<<<<< HEAD
  meta = {
    description = "Bringing the power of python to stream editing";
    homepage = "https://github.com/timbertson/piep";
    maintainers = with lib.maintainers; [ timbertson ];
    license = lib.licenses.gpl3Only;
=======
  meta = with lib; {
    description = "Bringing the power of python to stream editing";
    homepage = "https://github.com/timbertson/piep";
    maintainers = with maintainers; [ timbertson ];
    license = licenses.gpl3Only;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "piep";
  };
}
