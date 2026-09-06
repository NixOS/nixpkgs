{
  buildPythonPackage,
  # pkgs dependencies
  check,
  cppunit,
  pkg-config,
  subunit,

  # python dependencies
  fixtures,
  hypothesis,
  iso8601,
  pytestCheckHook,
  pyyaml,
  setuptools,
  testscenarios,
  testtools,
}:

buildPythonPackage {
  pname = "python-subunit";
  inherit (subunit)
    version
    src
    meta
    ;
  pyproject = true;

  postPatch = ''
    substituteInPlace setup.py \
      --replace "version=VERSION" 'version="${subunit.version}"'
  '';

  nativeBuildInputs = [
    pkg-config
    setuptools
  ];

  buildInputs = [
    check
    cppunit
  ];

  propagatedBuildInputs = [
    iso8601
    testtools
  ];

  nativeCheckInputs = [
    testscenarios
    hypothesis
    fixtures
    pytestCheckHook
    pyyaml
  ];

  enabledTestPaths = [ "python/tests" ];

  disabledTestPaths = [
    # these tests require testtools and don't work with pytest
    "python/tests/test_output_filter.py"
    "python/tests/test_test_protocol.py"
    "python/tests/test_test_protocol2.py"
  ];
}
