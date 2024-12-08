{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  defusedxml,
  django,
  pysaml2,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "djangosaml2";
  version = "1.9.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "IdentityPython";
    repo = "djangosaml2";
    rev = "refs/tags/v${version}";
    hash = "sha256-rbmEJuG2mgozpCFOXZUJFxv8v52IRQeaeAKfeUDACeU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    defusedxml
    pysaml2
  ];

  # Falsely complains that 'defusedxml>=0.4.1 not satisfied by version 0.8.0rc2'
  pythonRelaxDeps = [ "defusedxml" ];

  pythonImportsCheck = [ "djangosaml2" ];

  checkPhase = ''
    runHook preCheck

    python tests/run_tests.py

    runHook postCheck
  '';

  meta = {
    description = "Django SAML2 Service Provider based on pySAML2";
    homepage = "https://github.com/IdentityPython/djangosaml2";
    changelog = "https://github.com/IdentityPython/djangosaml2/blob/v${version}/CHANGES";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ melvyn2 ];
  };
}
