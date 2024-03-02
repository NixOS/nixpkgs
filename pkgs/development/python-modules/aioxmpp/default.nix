{ lib
, buildPythonPackage
, fetchFromGitHub
, aiosasl
, aioopenssl
, babel
, dnspython
, lxml
, multidict
, pyasn1
, pyasn1-modules
, pyopenssl
, pytz
, sortedcollections
, tzlocal
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aioxmpp";
  version = "0.13.3";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "horazont";
    repo = "aioxmpp";
    rev = "refs/tags/v${version}";
    hash = "sha256-bQPKEM5eKhFI3Kx3U1espdxqjnG4yUgOXmYCrd98PDo=";
  };

  propagatedBuildInputs = [
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

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    "benchmarks"
  ];

  disabledTests = [
    # AttributeError: 'zoneinfo.ZoneInfo' object has no attribute 'normalize'
    "test_convert_field_datetime_default_locale"
  ];

  meta = {
    changelog = "https://github.com/horazont/aioxmpp/blob/${src.rev}/docs/api/changelog.rst";
    description = "Pure-python XMPP library for asyncio";
    homepage = "https://github.com/horazont/aioxmpp";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
