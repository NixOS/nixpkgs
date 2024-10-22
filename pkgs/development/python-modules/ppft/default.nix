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
  version = "1.7.6.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dqQpp9e3TE10P226g1HljWK2Qy7WXfn+IEeQFg2rmW0=";
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
