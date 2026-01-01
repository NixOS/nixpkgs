{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ed25519-blake2b";
  version = "1.4.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cx6fk80awaZGSVdfNRmpn/4LseTPe/X18L5ROjnfc2M=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "ed25519_blake2b" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Ed25519 public-key signatures (BLAKE2b fork)";
    mainProgram = "edsig";
    homepage = "https://github.com/Matoking/python-ed25519-blake2b";
    changelog = "https://github.com/Matoking/python-ed25519-blake2b/releases/tag/${version}";
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      onny
      stargate01
    ];
  };
}
