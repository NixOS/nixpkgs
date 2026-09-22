{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "imapclient";
  version = "4.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mjs";
    repo = "imapclient";
    tag = finalAttrs.version;
    hash = "sha256-FqQfHO1kVdX5AreQichJYCMzXRRLzVJRYm/t9RouAxw=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

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
