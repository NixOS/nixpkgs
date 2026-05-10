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
  version = "1.7.8";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-X2ltTzl66bCvObH6/7MZV8Ud+8WjgVhWRy1PTocpN+4=";
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

  meta = {
    description = "Distributed and parallel Python";
    mainProgram = "ppserver";
    homepage = "https://ppft.readthedocs.io/";
    changelog = "https://github.com/uqfoundation/ppft/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
