{
  lib,
  authres,
  buildPythonPackage,
  dkimpy,
  dnspython,
  fetchFromGitHub,
  publicsuffix2,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "authheaders";
  version = "0.16.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ValiMail";
    repo = "authentication-headers";
    rev = "refs/tags/${version}";
    hash = "sha256-BFMZpSJ4qCEL42xTiM/D5dkatxohiCrOWAkNZHFUhac=";
  };

  build-system = [ setuptools ];

  dependencies = [
    authres
    dnspython
    dkimpy
    publicsuffix2
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "authheaders" ];

  disabledTests = [
    # Test fails with timeout even if the resolv.conf hack is present
    "test_authenticate_dmarc_psdsub"
  ];

  meta = with lib; {
    description = "Python library for the generation of email authentication headers";
    homepage = "https://github.com/ValiMail/authentication-headers";
    changelog = "https://github.com/ValiMail/authentication-headers/blob${version}/CHANGES";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "dmarc-policy-find";
  };
}
