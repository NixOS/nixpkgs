{ lib
, buildPythonPackage
, fetchPypi
, fido2
, keyring
, cryptography
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "ctap-keyring-device";
  version = "1.0.6";
  format = "pyproject";

  src = fetchPypi {
    inherit version pname;
    sha256 = "sha256-pEJkuz0wxKt2PkowmLE2YC+HPYa2ZiENK7FAW14Ec/Y=";
  };

  # removing optional dependency needing pyobjc
  postPatch = ''
    substituteInPlace setup.cfg --replace "pyobjc-framework-LocalAuthentication >= 7.1; platform_system=='Darwin'" ""
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    keyring
    fido2
    cryptography
  ];

  pythonImportsCheck = [ "ctap_keyring_device" ];

  meta = with lib; {
    description = "CTAP (client-to-authenticator-protocol) device backed by python's keyring library";
    homepage = "https://github.com/dany74q/ctap-keyring-device";
    license = licenses.mit;
    maintainers = with maintainers; [ dennajort ];
  };
}
