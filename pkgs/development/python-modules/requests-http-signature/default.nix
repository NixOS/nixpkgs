{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  http-message-signatures,
  http-sfv,
  pytestCheckHook,
  requests,
  urllib3,
}:

buildPythonPackage (finalAttrs: {
  pname = "requests-http-signature";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyauth";
    repo = "requests-http-signature";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v+oO1j3VqACNMg8DBpKPURuW6d/ST2CLtBm4NCx7nAw=";
  };

  pythonRelaxDeps = [ "urllib3" ];

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    http-message-signatures
    http-sfv
    requests
    urllib3
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "test/test.py" ];

  disabledTests = [
    # Test require network access
    "test_readme_example"
  ];

  pythonImportsCheck = [ "requests_http_signature" ];

  meta = {
    description = "Requests authentication module for HTTP Signature";
    homepage = "https://github.com/kislyuk/requests-http-signature";
    changelog = "https://github.com/pyauth/requests-http-signature/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
