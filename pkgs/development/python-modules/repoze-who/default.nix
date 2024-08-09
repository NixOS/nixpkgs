{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  zope-interface,
  webob,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "repoze-who";
  version = "3.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "repoze.who";
    inherit version;
    hash = "sha256-6VWt8AwfCwxxXoKJeaI37Ev37nCCe9l/Xhe/gnYNyzA=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    zope-interface
    webob
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # skip failing test
  # OSError: [Errno 22] Invalid argument
  preCheck = ''
    rm repoze/who/plugins/tests/test_htpasswd.py
  '';

  pythonImportsCheck = [ "repoze.who" ];

  pythonNamespaces = [
    "repoze"
    "repoze.who"
    "repoze.who.plugins"
  ];

  meta = with lib; {
    description = "WSGI Authentication Middleware / API";
    homepage = "http://www.repoze.org";
    changelog = "https://github.com/repoze/repoze.who/blob/${version}/CHANGES.rst";
    license = licenses.bsd0;
    maintainers = [ ];
  };
}
