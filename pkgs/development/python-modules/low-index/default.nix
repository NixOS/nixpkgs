{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "low-index";
  version = "1.2.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    inherit version;
    pname = "low_index";
    sha256 = "sha256-Pn5hDe8I75GxXHqoB3OWzaauWxnhs5NXF4tCnqiGFyg=";
  };

  build-system = [ setuptools ];

  doCheck = true;

  pythonImportsCheck = [ "low_index" ];

  meta = with lib; {
    description = "Enumerates low index subgroups of a finitely presented group";
    homepage = "https://github.com/3-manifolds/low_index";
    license = licenses.gpl2;
    maintainers = with maintainers; [ noiioiu ];
  };
}
