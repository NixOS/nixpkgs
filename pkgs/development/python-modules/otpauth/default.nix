{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "otpauth";
  version = "2.2.1";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Fpp629cV/KaH9qZtAszb78Ip+0n4pjS5WNKG+QgTTVk=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "otpauth" ];

  meta = {
    description = "Implements one time password of HOTP/TOTP";
    homepage = "https://otp.authlib.org/";
    changelog = "https://github.com/authlib/otpauth/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ erictapen ];
  };
}
