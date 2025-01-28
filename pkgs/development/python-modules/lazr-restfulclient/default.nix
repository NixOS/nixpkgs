{
  lib,
  buildPythonPackage,
  fetchPypi,
  distro,
  httplib2,
  oauthlib,
  setuptools,
  six,
  wadllib,
  fixtures,
  lazr-uri,
  pytestCheckHook,
  wsgi-intercept,
}:

buildPythonPackage rec {
  pname = "lazr-restfulclient";
  version = "0.14.6";
  pyproject = true;

  src = fetchPypi {
    pname = "lazr.restfulclient";
    inherit version;
    hash = "sha256-Q/EqHTlIRjsUYgOMR7Qp3LXkLgun8uFlEbArpdKt/9s=";
  };

  build-system = [ setuptools ];

  dependencies = [
    distro
    httplib2
    oauthlib
    setuptools
    six
    wadllib
  ];

  # E   ModuleNotFoundError: No module named 'lazr.uri'
  doCheck = false;
  nativeCheckInputs = [
    fixtures
    lazr-uri
    pytestCheckHook
    wsgi-intercept
  ];

  pythonImportsCheck = [ "lazr.restfulclient" ];

  pythonNamespaces = [ "lazr" ];

  meta = {
    description = "Programmable client library that takes advantage of the commonalities among";
    homepage = "https://launchpad.net/lazr.restfulclient";
    changelog = "https://git.launchpad.net/lazr.restfulclient/tree/NEWS.rst?h=${version}";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ ];
  };
}
