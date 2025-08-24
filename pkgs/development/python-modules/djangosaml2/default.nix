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
  version = "1.11.1-1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "IdentityPython";
    repo = "djangosaml2";
    tag = "v${version}";
    hash = "sha256-f7VgysfGpwt4opmXXaigRsOBS506XB/jZV1zRiYwZig=";
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
    changelog = "https://github.com/IdentityPython/djangosaml2/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ melvyn2 ];
  };
}
