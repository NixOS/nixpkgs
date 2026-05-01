{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pyyaml,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyngrok";
  version = "8.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-bnqvkLQwhq0lUIoRIkI2CAA/cS2ZiDGd33vlBDECgQE=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyyaml ];

  pythonImportsCheck = [ "pyngrok" ];

  meta = {
    description = "Python wrapper for ngrok";
    homepage = "https://github.com/alexdlaird/pyngrok";
    changelog = "https://github.com/alexdlaird/pyngrok/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wegank ];
  };
})
