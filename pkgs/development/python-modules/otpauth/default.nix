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
  version = "2.1.1";

  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4J7WOgGzWs14t7sPmB/c29HZ2cAb4aPg1wJMZdDnTio=";
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
