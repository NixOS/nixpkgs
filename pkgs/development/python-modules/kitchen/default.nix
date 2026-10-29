{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage (finalAttrs: {
  pname = "kitchen";
  version = "1.2.6";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-uEz1gvG9FVa2DrxzcLnTMeuSR7awcM6J3+lZy6LAsDw=";
  };

  # Waiting for upstream's clean-up
  doCheck = false;

  pythonImportsCheck = [ "kitchen" ];

  meta = {
    description = "Kitchen contains a cornucopia of useful code";
    homepage = "https://github.com/fedora-infra/kitchen";
    changelog = "https://github.com/fedora-infra/kitchen/blob/${finalAttrs.version}/NEWS.rst";
    license = lib.licenses.lgpl2Only;
    maintainers = [ ];
  };
})
