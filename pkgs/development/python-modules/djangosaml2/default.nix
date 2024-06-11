{ lib, buildPythonPackage, fetchFromGitHub, defusedxml, django, pysaml2
, pythonOlder, }:

buildPythonPackage rec {
  pname = "djangosaml2";
  version = "1.9.3";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "IdentityPython";
    repo = "djangosaml2";
    rev = "refs/tags/v${version}";
    hash = "sha256-rbmEJuG2mgozpCFOXZUJFxv8v52IRQeaeAKfeUDACeU=";
  };

  propagatedBuildInputs = [ django defusedxml pysaml2 ];

  pythonImportsCheck = [ "djangosaml2" ];

  checkPhase = ''
    runHook preCheck

    python tests/run_tests.py

    runHook postCheck
  '';

  meta = with lib; {
    description = "Django SAML2 Service Provider based on pySAML2";
    homepage = "https://github.com/IdentityPython/djangosaml2";
    changelog =
      "https://github.com/IdentityPython/djangosaml2/blob/v${version}/CHANGES";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
