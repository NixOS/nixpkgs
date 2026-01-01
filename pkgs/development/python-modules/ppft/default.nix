{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  python,
  pythonOlder,
  six,
}:

buildPythonPackage rec {
  pname = "ppft";
  version = "1.7.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8/d0SM/iTCuNIpa22HMigLJQQaPz4fVRhWxkUdPgG5Y=";
  };

  propagatedBuildInputs = [ six ];

  # darwin seems to hang
  doCheck = !stdenv.hostPlatform.isDarwin;

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m ppft.tests
    runHook postCheck
  '';

  pythonImportsCheck = [ "ppft" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Distributed and parallel Python";
    mainProgram = "ppserver";
    homepage = "https://ppft.readthedocs.io/";
    changelog = "https://github.com/uqfoundation/ppft/releases/tag/${version}";
<<<<<<< HEAD
    license = lib.licenses.bsd3;
=======
    license = licenses.bsd3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
