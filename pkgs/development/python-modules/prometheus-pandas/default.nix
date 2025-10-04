{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  numpy,
  pandas,
}:

buildPythonPackage rec {
  pname = "prometheus-pandas";
  version = "0.3.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1eaTmNui3cAisKEhBMEpOv+UndJZwb4GGK2M76xiy7k=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    numpy
    pandas
  ];

  # There are no tests. :(
  doCheck = false;

  pythonImportsCheck = [ "prometheus_pandas" ];

  meta = with lib; {
    homepage = "https://github.com/dcoles/prometheus-pandas";
    license = licenses.mit;
    description = "Pandas integration for Prometheus";
    maintainers = with maintainers; [ viktornordling ];
  };
}
