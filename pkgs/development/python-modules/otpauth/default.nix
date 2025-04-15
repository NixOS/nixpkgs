{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "otpauth";
  version = "2.2.0";

  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ev2uZNBmT/v6/a39weyP5XGs0OcaYveSM9072giNOcI=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ pname ];

  meta = with lib; {
    description = "Implements one time password of HOTP/TOTP";
    homepage = "https://otp.authlib.org/";
    changelog = "https://github.com/authlib/otpauth/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ erictapen ];
  };
}
