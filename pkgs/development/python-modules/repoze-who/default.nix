{ lib
, buildPythonPackage
, fetchPypi
, zope_interface
, webob
}:

buildPythonPackage rec {
  pname = "repoze-who";
  version = "3.0.0";

  src = fetchPypi {
    pname = "repoze.who";
    inherit version;
    hash = "sha256-6VWt8AwfCwxxXoKJeaI37Ev37nCCe9l/Xhe/gnYNyzA=";
  };

  propagatedBuildInputs = [ zope_interface webob ];

  # skip failing test
  # OSError: [Errno 22] Invalid argument
  preCheck = ''
    rm repoze/who/plugins/tests/test_htpasswd.py
  '';

  meta = with lib; {
    description = "WSGI Authentication Middleware / API";
    homepage = "http://www.repoze.org";
    changelog = "https://github.com/repoze/repoze.who/blob/${version}/CHANGES.rst";
    license = licenses.bsd0;
    maintainers = with maintainers; [ ];
  };
}
