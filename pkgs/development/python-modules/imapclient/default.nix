{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "imapclient";
  version = "4.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mjs";
    repo = "imapclient";
    tag = finalAttrs.version;
    hash = "sha256-tKlqzUHvvC27Nbv1Go2MJd424JDLUpg5PAnYryl2G+o=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    # NIX_SSL_CERT_FILE is set to an invalid path (/no-cert-file.crt)
    # by default and overrides SSL_CERT_FILE when it's set. This
    # results in the tests relying on modifying SSL_CERT_FILE failing.
    unset NIX_SSL_CERT_FILE
  '';

  disabledTests = [
    # only works on Python < 3.11
    "test_python_38_rejects_connect_timeout"
  ];

  pythonImportsCheck = [
    "imapclient"
    "imapclient.response_types"
    "imapclient.exceptions"
    "imapclient.testable_imapclient"
    "imapclient.tls"
  ];

  meta = {
    changelog = "https://github.com/mjs/imapclient/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://imapclient.readthedocs.io";
    description = "Easy-to-use, Pythonic and complete IMAP client library";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      almac
      dotlambda
    ];
  };
})
