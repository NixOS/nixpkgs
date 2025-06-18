{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyairports";
  version = "2.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PWCnJ/zk2oG5xjk+qK4LM9Z7N+zjRN/8hj90njrWK80=";
  };

  build-system = [ setuptools ];

  doCheck = false;

  pythonImportsCheck = [ "pyairports" ];

  meta = with lib; {
    description = "pyairports is a package which enables airport lookup by 3-letter IATA code.";
    homepage = "https://github.com/ozeliger/pyairports";
    license = licenses.asl20;
    maintainers = with maintainers; [ cfhammill ];
  };
}
