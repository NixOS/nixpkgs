{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  setuptools,

  typing-extensions,
  xeddsa,

  pytestCheckHook,
  oldmemo,
  twomemo,
  pytest-asyncio,
  pytest-cov-stub,

  # passthru
  omemo,
}:
buildPythonPackage rec {
  pname = "omemo";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Syndace";
    repo = "python-omemo";
    tag = "v${version}";
    hash = "sha256-uA8Nv8xT6ROlE9eM/Oz2j5HsYtvWzKEu7DSd/ws+WZY=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    typing-extensions
    xeddsa
  ];

  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
    oldmemo
    twomemo
    pytest-asyncio
    pytest-cov-stub
  ]
  ++ oldmemo.optional-dependencies.xml;

  pythonImportsCheck = [
    "omemo"
  ];

  passthru.tests = {
    pytest = omemo.overridePythonAttrs {
      doCheck = true;
    };
  };

  meta = {
    description = "Open python implementation of the OMEMO Multi-End Message and Object Encryption protocol";
    longDescription = ''
      A complete implementation of XEP-0384 on protocol-level, i.e. more than just the cryptography.
      python-omemo supports different versions of the specification through so-called backends.

      A backend for OMEMO in the urn:xmpp:omemo:2 namespace (the most recent version of the specification) is available
      in the python-twomemo Python package.
      A backend for (legacy) OMEMO in the eu.siacs.conversations.axolotl namespace is available in the python-oldmemo
      package.
      Multiple backends can be loaded and used at the same time, the library manages their coexistence transparently.
    '';
    homepage = "https://github.com/Syndace/python-omemo";
    changelog = "https://github.com/Syndace/python-omemo/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    teams = with lib.teams; [ ngi ];
    maintainers = with lib.maintainers; [ themadbit ];
  };
}
