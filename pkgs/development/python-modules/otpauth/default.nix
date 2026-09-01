{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "otpauth";
  version = "2.2.2";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1DBnkO8b+zsYIWz/cWAyj4nqJqBPiQedemAhb3gIS8w=";
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
