{ lib
, buildPythonPackage
, fetchPypi
, pythonRelaxDepsHook
, setuptools-scm
# install requirements
, fido2
, keyring
, cryptography
# test requirements
, pytestCheckHook
}:

let
  fido2_0 = fido2.overridePythonAttrs (oldAttrs: rec {
    version = "0.9.3";
    format = "setuptools";
    src = fetchPypi {
      inherit (oldAttrs) pname;
      inherit version;
      hash = "sha256-tF6JphCc/Lfxu1E3dqotZAjpXEgi+DolORi5RAg0Zuw=";
    };
  });
in
buildPythonPackage rec {
  pname = "ctap-keyring-device";
  version = "1.0.6";
  format = "setuptools";

  src = fetchPypi {
    inherit version pname;
    sha256 = "sha256-pEJkuz0wxKt2PkowmLE2YC+HPYa2ZiENK7FAW14Ec/Y=";
  };

  # removing optional dependency needing pyobjc
  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--flake8 --black --cov" ""
  '';

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools-scm
  ];

  pythonRemoveDeps = [
    # This is a darwin requirement missing pyobjc
    "pyobjc-framework-LocalAuthentication"
  ];

  propagatedBuildInputs = [
    keyring
    fido2_0
    cryptography
  ];

  pythonImportsCheck = [ "ctap_keyring_device" ];

  checkInputs = [ pytestCheckHook ];

  disabledTests = [
    # Disabled tests that needs pyobjc or windows
    "touch_id_ctap_user_verifier"
    "windows_hello_ctap_user_verifier"
  ];

  meta = with lib; {
    description = "CTAP (client-to-authenticator-protocol) device backed by python's keyring library";
    homepage = "https://github.com/dany74q/ctap-keyring-device";
    license = licenses.mit;
    maintainers = with maintainers; [ jbgosselin ];
  };
}
