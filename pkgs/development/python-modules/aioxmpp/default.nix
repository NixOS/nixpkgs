{
  lib,
  aioopenssl,
  aiosasl,
  babel,
  buildPythonPackage,
  dnspython,
  fetchFromGitea,
  lxml,
  multidict,
  pyasn1-modules,
  pyasn1,
  pyopenssl,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  pytz,
  setuptools,
  sortedcollections,
  tzlocal,
}:

buildPythonPackage rec {
  pname = "aioxmpp";
  version = "0.13.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "jssfr";
    repo = "aioxmpp";
    tag = "v${version}";
    hash = "sha256-bQPKEM5eKhFI3Kx3U1espdxqjnG4yUgOXmYCrd98PDo=";
  };

  postPatch = ''
    substituteInPlace tests/bookmarks/test_service.py \
      --replace-fail 'can only assign an iterable$' 'must assign iterable'
    substituteInPlace tests/test_utils.py \
      --replace-fail 'property of .* has no' 'property .*of .* has no'
  '';

  pythonRelaxDeps = [
    "lxml"
  ];

  build-system = [ setuptools ];

  dependencies = [
    aiosasl
    aioopenssl
    babel
    dnspython
    lxml
    multidict
    pyasn1
    pyasn1-modules
    pyopenssl
    pytz
    sortedcollections
    tzlocal
  ];

  pythonImportsCheck = [
    "aioxmpp"
    "aioxmpp.node"
    "aioxmpp.security_layer"
    "aioxmpp.stanza"
    "aioxmpp.stream"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [ "benchmarks" ];

  disabledTests = [
    # AttributeError: 'zoneinfo.ZoneInfo' object has no attribute 'normalize'
    "test_convert_field_datetime_default_locale"
  ]
  ++ lib.optionals (pythonAtLeast "3.12") [
    # asyncio issues
    "test_is_abstract"
    "Testbackground"
    "TestCapturingXSO"
    "Testcheck_x509"
    "TestClient"
    "TestIntegerType"
    "TestStanzaStream"
    "TestStanzaToken"
    "TestXMLStream"
  ];

  meta = {
    description = "Pure-python XMPP library for asyncio";
    homepage = "https://codeberg.org/jssfr/aioxmpp";
    changelog = "https://codeberg.org/jssfr/aioxmpp/blob/${src.rev}/docs/api/changelog.rst";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
