{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  cryptography,
  defusedxml,
  lxml,
  pytest-cov-stub,
  pytestCheckHook,
  python-dateutil,
  setuptools,
  signxml,
  stdenv,
}:

buildPythonPackage rec {
  pname = "python-pskc";
  version = "1.4-unstable-2026-07-18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "arthurdejong";
    repo = "python-pskc";
    rev = "6bcd0274db24467f7c9c410b31461228f70d6620";
    hash = "sha256-0Pf803akJdTTCeMYC0/CwZNMySYQReFNbt69nl24AII=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    cryptography
    python-dateutil
  ];

  optional-dependencies = {
    defuse = [ defusedxml ];
    lxml = [ lxml ];
    signature = [ signxml ];
  };

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  preCheck = ''
    export TZ=Europe/Amsterdam
  '';

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # Assert difference between tzinfo=tzutc() and tzinfo=tzlocal()
    "tests/test_draft_ietf_keyprov_pskc_02.doctest::test_draft_ietf_keyprov_pskc_02.doctest"
    "tests/test_draft_keyprov.doctest::test_draft_keyprov.doctest"
    "tests/test_feitian.doctest::test_feitian.doctest"
    "tests/test_misc.doctest::test_misc.doctest"
    "tests/test_rfc6030.doctest::test_rfc6030.doctest"
    "tests/test_yubico.doctest::test_yubico.doctest"
  ];

  pythonImportsCheck = [ "pskc" ];

  meta = {
    changelog = "https://github.com/arthurdejong/python-pskc/releases/tag/${version}";
    description = "Python module for handling PSKC files";
    homepage = "https://github.com/arthurdejong/python-pskc";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
  };
}
