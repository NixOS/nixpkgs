{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

, keyring
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "keyrings.passwordstore";
  version = "0.1.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pylZw45FUtLHzUV4cDyl/nT8tCZwNj4Jf41MMlyskoU=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  nativeCheckInputs = [
    keyring
  ];

  pythonImportsCheck = [
    "keyrings.passwordstore.backend"
  ];

  meta = {
    license = lib.licenses.mit;
    description = "Keyring backend for password-store";
    homepage = "https://github.com/stv0g/keyrings.passwordstore";
    maintainers = [ lib.maintainers.shlevy ];
  };
}
