{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  stdenv,
  pbr,
  python-ldap,
  prettytable,
  six,
  unittestCheckHook,
  fixtures,
  testresources,
  testtools,
}:

buildPythonPackage rec {
  pname = "ldappool";
  version = "3.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "ldappool";
    inherit version;
    hash = "sha256-S7WbfWsRQH9I7gGngSZ+PIupjZH0JoBqxyCGEq4Ie4Y=";
  };

  build-system = [
    setuptools
    pbr
  ];

  dependencies = [
    python-ldap
    prettytable
    six
  ];

  nativeCheckInputs = [
    unittestCheckHook
    fixtures
    testresources
    testtools
  ];

  pythonImportsCheck = [ "ldappool" ];

  disabledTests = lib.optionals stdenv.buildPlatform.isDarwin [
    # very flaky on aarch64-darwin, especially under high system load
    # always fails at this assertion:
    #   https://opendev.org/openstack/ldappool/src/commit/322e0d753f20a9eb7f9bd27afe2271b33c6aedbb/ldappool/tests/test_ldappool.py#L203
    "test_pool_full"
  ];

  meta = {
    description = "Simple connector pool for python-ldap";
    homepage = "https://opendev.org/openstack/ldappool/";
    license = with lib.licenses; [
      mpl11
      lgpl21Plus
      gpl2Plus
    ];
  };
}
