{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  poetry-core,

  # dependencies
  click,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "mouser";
  version = "0.1.6";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-Fkxv9hRfUZ/GCWNySiPo+xB0EyK4k0oP6nLS4loRkyg=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    click
    requests
  ];

  meta = {
    changelog = "https://github.com/sparkmicro/mouser-api/releases/tag/${finalAttrs.version}";
    description = "Python API for mouser.com";
    homepage = "https://githib.com/sparkmicro/mouser-api/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      chordtoll
    ];
  };
})
