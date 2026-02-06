{
  lib,
  buildPythonPackage,
  decorator,
  fetchPypi,
  setuptools,
  setuptools-scm,
  formencode,
  httpretty,
  libxml2,
  lxml,
  mock,
  nocasedict,
  nocaselist,
  pbr,
  ply,
  pytestCheckHook,
  pytz,
  pyyaml,
  requests,
  requests-mock,
  six,
  testfixtures,
  yamlloader,
}:

buildPythonPackage rec {
  pname = "pywbem";
  version = "1.8.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-P+/sNPckpVHkLKOJ0ILQKf7QO0/xSsyO9cfLkv3aE1s=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools-scm>=9.2.0" "setuptools-scm"
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    mock
    nocasedict
    nocaselist
    pbr
    ply
    pyyaml
    requests
    six
    yamlloader
  ];

  nativeCheckInputs = [
    decorator
    formencode
    httpretty
    libxml2
    lxml
    pytestCheckHook
    pytz
    requests-mock
    testfixtures
  ];

  pythonImportsCheck = [ "pywbem" ];

  disabledTestPaths = [
    "tests/leaktest" # requires 'yagot'
    "tests/end2endtest" # requires 'pytest_easy_server'
  ];

  meta = {
    description = "Support for the WBEM standard for systems management";
    homepage = "https://pywbem.github.io";
    changelog = "https://github.com/pywbem/pywbem/blob/${version}/docs/changes.rst";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
  };
}
