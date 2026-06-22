{
  lib,
  buildPythonPackage,
  fetchPypi,
  gitpython,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "git-sweep";
  version = "0.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-zSnxw3JHsFru9fOZSJZX+XOu144uJ0DaIKYlAtoHV7M=";
  };

  build-system = [ setuptools ];
  dependencies = [ gitpython ];

  pythonImportsCheck = [ "gitsweep" ];

  meta = {
    description = "Command-line tool that helps you clean up Git branches";
    mainProgram = "git-sweep";
    homepage = "https://github.com/arc90/git-sweep";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pSub ];
  };
})
