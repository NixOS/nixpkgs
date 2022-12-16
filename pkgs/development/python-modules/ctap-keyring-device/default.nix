{ lib
, buildPythonPackage
, fetchPypi
# , six
# , cryptography
# , mock
# , pyfakefs
# , unittestCheckHook
}:

buildPythonPackage rec {
  pname = "ctap-keyring-device";
  version = "1.0.6";
  format = "wheel";

  src = fetchPypi {
    inherit version format;
    pname = "ctap_keyring_device";
    sha256 = "sha256-EsCKq9YDGL1CI+69EkY+l5uOv+w2xZQwWbLsoibtFCc=";
  };

  # propagatedBuildInputs = [ six cryptography ];

  # checkInputs = [ unittestCheckHook mock pyfakefs ];

  # unittestFlagsArray = [ "-v" ];

  # pythonImportsCheck = [ "fido2" ];

  meta = with lib; {
    description = "CTAP (client-to-authenticator-protocol) device backed by python's keyring library";
    homepage = "https://github.com/dany74q/ctap-keyring-device";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
