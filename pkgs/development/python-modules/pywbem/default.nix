{
  lib,
  buildPythonPackage,
  decorator,
  fetchPypi,
  formencode,
  httpretty,
  libxml2,
  lxml,
  mock,
  nocasedict,
  nocaselist,
  pbr,
  ply,
  pytest,
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
  version = "1.9.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZcH/lyzqLwF7BnlfR8CtdEL4Q0/2Q6VEBQwQcmcE9qs=";
  };

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
    pytest
    pytz
    requests-mock
    testfixtures
  ];

  pythonImportsCheck = [ "pywbem" ];

  meta = {
    description = "Support for the WBEM standard for systems management";
    homepage = "https://pywbem.github.io";
    changelog = "https://github.com/pywbem/pywbem/blob/${version}/docs/changes.rst";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
  };
}
