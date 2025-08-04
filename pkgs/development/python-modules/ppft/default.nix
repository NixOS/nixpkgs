{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  python,
  six,
}:

buildPythonPackage rec {
  pname = "ppft";
  version = "1.7.7";
  format = "setuptools";

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

  meta = with lib; {
    description = "Distributed and parallel Python";
    mainProgram = "ppserver";
    homepage = "https://ppft.readthedocs.io/";
    changelog = "https://github.com/uqfoundation/ppft/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
