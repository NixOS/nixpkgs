{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
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

  meta = with lib; {
    description = "A simple connector pool for python-ldap";
    homepage = "https://opendev.org/openstack/ldappool/";
    license = with licenses; [
      mpl11
      lgpl21Plus
      gpl2Plus
    ];
  };
}
