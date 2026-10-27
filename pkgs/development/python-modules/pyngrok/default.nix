{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pyyaml,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyngrok";
  version = "9.0.3";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-jvv9+nppzOtIV+AyfQ8u50VCfAPr9z9vHwewmtJHBhs=";
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
