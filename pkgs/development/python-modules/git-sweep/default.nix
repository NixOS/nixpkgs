{
  lib,
  buildPythonPackage,
  fetchPypi,
  gitpython,
}:

buildPythonPackage rec {
  pname = "git-sweep";
  version = "0.1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zSnxw3JHsFru9fOZSJZX+XOu144uJ0DaIKYlAtoHV7M=";
  };

  propagatedBuildInputs = [ gitpython ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "gitsweep" ];

  meta = {
    description = "Command-line tool that helps you clean up Git branches";
    mainProgram = "git-sweep";
    homepage = "https://github.com/arc90/git-sweep";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pSub ];
  };
}
