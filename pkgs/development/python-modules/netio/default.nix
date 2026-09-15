{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pyopenssl,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "netio";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "netioproducts";
    repo = "PyNetio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OmYSa8boZPAqw1PXc3BmLAxGiNgnAYiXbHTk5QF/5b8=";
  };

  pythonRelaxDeps = [ "pyopenssl" ];

  build-system = [ poetry-core ];

  dependencies = [
    requests
    pyopenssl
  ];

  pythonImportsCheck = [ "Netio" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Module for interacting with NETIO devices";
    homepage = "https://github.com/netioproducts/PyNetio";
    changelog = "https://github.com/netioproducts/PyNetio/blob/v${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "Netio";
  };
})
