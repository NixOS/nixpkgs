{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "bangla";
  version = "0.0.6";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-r/5AaVajaWNRwTRkY3O59+aWewrJ2Rnclnc29n3GCxs=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "bangla" ];

  # https://github.com/arsho/bangla/issues/5
  doCheck = false;

  meta = {
    description = "Bangla is a package for Bangla language users with various functionalities including Bangla date and Bangla numeric conversation";
    homepage = "https://github.com/arsho/bangla";
    license = lib.licenses.mit;
    teams = [ lib.teams.tts ];
  };
})
