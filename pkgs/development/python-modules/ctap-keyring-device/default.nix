{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  # install requirements
  six,
  fido2,
  keyring,
  cryptography,
  # test requirements
  pytestCheckHook,
  unittestCheckHook,
  mock,
}:

let
  fido2_0 = fido2.overridePythonAttrs (oldAttrs: rec {
    version = "0.9.3";
    src = fetchPypi {
      inherit (oldAttrs) pname;
      inherit version;
      hash = "sha256-tF6JphCc/Lfxu1E3dqotZAjpXEgi+DolORi5RAg0Zuw=";
    };
    postPatch = ''
      substituteInPlace setup.py test/test_attestation.py \
        --replace-fail "distutils.version" "setuptools._distutils.version"
    '';
    build-system = [ setuptools-scm ];
    dependencies = oldAttrs.dependencies ++ [ six ];
    nativeCheckInputs = [
      unittestCheckHook
      mock
    ];
  });
in
buildPythonPackage rec {
  pname = "ctap-keyring-device";
  version = "1.0.6";
  pyproject = true;

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-pEJkuz0wxKt2PkowmLE2YC+HPYa2ZiENK7FAW14Ec/Y=";
  };

  # removing optional dependency needing pyobjc
  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--flake8 --black --cov" ""
  '';

  pythonRemoveDeps = [
    # This is a darwin requirement missing pyobjc
    "pyobjc-framework-LocalAuthentication"
  ];

  build-system = [ setuptools-scm ];

  dependencies = [
    keyring
    fido2_0
    cryptography
  ];

  pythonImportsCheck = [ "ctap_keyring_device" ];

  nativeCheckInputs = [ pytestCheckHook ];

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
