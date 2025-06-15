{
  lib,
  buildPythonPackage,
  fetchPypi,
  importlib-resources,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "asdf-standard";
  version = "1.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "asdf_standard";
    inherit version;
    hash = "sha256-WViWHzmd6tIACnhyTaN/Wu6wSZp4C72a5Pw+y+Pq7WQ=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.9") [ importlib-resources ];

  # Circular dependency on asdf
  doCheck = false;

  pythonImportsCheck = [ "asdf_standard" ];

  meta = with lib; {
    description = "Standards document describing ASDF";
    homepage = "https://github.com/asdf-format/asdf-standard";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
