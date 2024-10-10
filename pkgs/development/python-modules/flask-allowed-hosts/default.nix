{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  flask,
}:

buildPythonPackage rec {
  pname = "flask-allowed-hosts";
  version = "1.1.2";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "flask_allowed_hosts";
    hash = "sha256-l25bZlJkOVI+S+HtAK22ZGULP95evx2NASA9ViIax7Q=";
  };

  build-system = [ setuptools ];

  dependencies = [ flask ];

  pythonImportsCheck = [ "flask_allowed_hosts" ];

  meta = with lib; {
    description = "Flask extension that helps you limit access to your API endpoints";
    homepage = "https://github.com/riad-azz/flask-allowedhosts";
    license = licenses.mit;
    maintainers = with maintainers; [ erictapen ];
  };
}
