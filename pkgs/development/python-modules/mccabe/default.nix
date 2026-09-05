{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
}:

buildPythonPackage (finalAttrs: {
  pname = "mccabe";
  version = "0.7.0";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-NI4CQMM7YLvfTlIxku+RnyjLLD19XHeU90AJKQ8jYyU=";
  };

  buildInputs = [ pytest ];

  # https://github.com/PyCQA/mccabe/issues/93
  doCheck = false;

  __structuredAttrs = true;

  meta = {
    description = "McCabe checker, plugin for flake8";
    homepage = "https://github.com/flintwork/mccabe";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
