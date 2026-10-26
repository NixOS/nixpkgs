{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  colorama,
}:

buildPythonPackage (finalAttrs: {
  pname = "pretty-errors";
  version = "1.2.25";
  pyproject = true;

  src = fetchPypi {
    pname = "pretty_errors";
    inherit (finalAttrs) version;
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

  meta = {
    description = "Prettifies Python exception output to make it legible";
    homepage = "https://pypi.org/project/pretty-errors/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
