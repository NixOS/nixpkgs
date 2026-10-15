{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "bangla";
  version = "0.0.5";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-rX2/rUUf9g4otYMNX0LDPXSIDRbIE8xRl95NamHzRwQ=";
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
