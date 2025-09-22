{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  colorama,
}:

buildPythonPackage rec {
  pname = "pretty-errors";
  version = "1.2.25";
  pyproject = true;

  src = fetchPypi {
    pname = "pretty_errors";
    inherit version;
    hash = "sha256-oWulx1LIfCY7+S+LS1hiTjseKScak5H1ZPErhuk8Z1U=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [ colorama ];

  pythonImportsCheck = [ "pretty_errors" ];

  # No test
  doCheck = false;

  meta = with lib; {
    description = "Prettifies Python exception output to make it legible";
    homepage = "https://pypi.org/project/pretty-errors/";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
