{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  hypothesis,
  openssl,
  pytestCheckHook,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "ecdsa";
  version = "0.19.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tlsfuzzer";
    repo = "python-ecdsa";
    tag = "python-ecdsa-${version}";
    hash = "sha256-PjOjHQziQ9ohXH82Ocaowj/AtsXHMHDhatFPQNccyC8=";
  };

  build-system = [ setuptools ];

  dependencies = [ six ];

  pythonImportsCheck = [ "ecdsa" ];

  nativeCheckInputs = [
    hypothesis
    openssl # Only needed for tests
    pytestCheckHook
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "python-ecdsa-";
  };

  meta = {
    changelog = "https://github.com/tlsfuzzer/python-ecdsa/blob/${src.tag}/NEWS";
    description = "ECDSA cryptographic signature library";
    homepage = "https://github.com/warner/python-ecdsa";
    license = lib.licenses.mit;
    knownVulnerabilities = [
      # "I don't want people to use this library in production environments.
      # It's a teaching tool, it's a testing tool, it's absolutely not an
      # production grade implementation."
      # https://github.com/tlsfuzzer/python-ecdsa/issues/330
      "CVE-2024-23342"
    ];
  };
}
