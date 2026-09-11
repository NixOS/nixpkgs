{
  lib,
  authres,
  buildPythonPackage,
  dkimpy,
  dnspython,
  fetchFromGitHub,
  publicsuffix2,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "authheaders";
  version = "0.16.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ValiMail";
    repo = "authentication-headers";
    tag = version;
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

  meta = {
    description = "Python library for the generation of email authentication headers";
    homepage = "https://github.com/ValiMail/authentication-headers";
    changelog = "https://github.com/ValiMail/authentication-headers/blob${version}/CHANGES";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "dmarc-policy-find";
  };
}
