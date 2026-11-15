{
  lib,
  buildPythonPackage,
  fetchPypi,
  nix-update-script,
  ply,
  poetry-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "puppetparser";
  version = "0.2.14";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-di8R1ysLX6zjml6blh9S6JLA4FqFoLLPLFpDe5HHWdw=";
  };

  build-system = [ poetry-core ];

  dependencies = [ ply ];

  pythonImportsCheck = [ "puppetparser" ];

  # Tests are not shipped
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Parser from Puppet to an object model";
    homepage = "https://pypi.org/project/puppetparser";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
