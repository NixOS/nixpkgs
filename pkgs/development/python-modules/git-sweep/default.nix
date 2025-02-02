{
  lib,
  buildPythonPackage,
  fetchPypi,
  gitpython,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "git-sweep";
  version = "0.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zSnxw3JHsFru9fOZSJZX+XOu144uJ0DaIKYlAtoHV7M=";
  };

  propagatedBuildInputs = [ gitpython ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "gitsweep" ];

  meta = with lib; {
    description = "Command-line tool that helps you clean up Git branches";
    mainProgram = "git-sweep";
    homepage = "https://github.com/arc90/git-sweep";
    license = licenses.mit;
    maintainers = with maintainers; [ pSub ];
  };
}
