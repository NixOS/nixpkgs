{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pyopenssl,
  requests,
}:

buildPythonPackage rec {
  pname = "netio";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "netioproducts";
    repo = "PyNetio";
    tag = "v${version}";
    hash = "sha256-OmYSa8boZPAqw1PXc3BmLAxGiNgnAYiXbHTk5QF/5b8=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  pythonRelaxDeps = [ "pyopenssl" ];

  propagatedBuildInputs = [
    requests
    pyopenssl
  ];

  pythonImportsCheck = [ "Netio" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Module for interacting with NETIO devices";
    mainProgram = "Netio";
    homepage = "https://github.com/netioproducts/PyNetio";
    changelog = "https://github.com/netioproducts/PyNetio/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
