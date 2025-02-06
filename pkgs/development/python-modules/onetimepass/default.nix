{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  six,
  timecop,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "onetimepass";
  version = "1.0.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tadeck";
    repo = "onetimepass";
    tag = "v${version}";
    hash = "sha256-cHJg3vdUpWp5+HACIeTGrqkHKUDS//aQICSjPKgwu3I=";
  };

  build-system = [ setuptools ];

  dependencies = [ six ];

  nativeCheckInputs = [
    timecop
    unittestCheckHook
  ];

  pythonImportsCheck = [ "onetimepass" ];

  meta = with lib; {
    description = "One-time password library for HMAC-based (HOTP) and time-based (TOTP) passwords";
    homepage = "https://github.com/tadeck/onetimepass";
    changelog = "https://github.com/tadeck/onetimepass/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ zakame ];
  };
}
