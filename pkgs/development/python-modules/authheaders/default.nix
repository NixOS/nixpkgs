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
  version = "0.16.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ValiMail";
    repo = "authentication-headers";
    rev = "refs/tags/${version}";
    hash = "sha256-/vxUUSWwysYQzcy2AmkF4f8R59FHRnBfFlPRpfM9e5o=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
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
    mainProgram = "dmarc-policy-find";
    homepage = "https://github.com/ValiMail/authentication-headers";
    changelog = "https://github.com/ValiMail/authentication-headers/blob${version}/CHANGES";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
