{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  wheel,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydeprecate";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Borda";
    repo = "pyDeprecate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M3h5m+MqUYl8902YUqKqPfLpZXF3yQjlXP8f0ehnHds=";
  };

  build-system = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "deprecate" ];

  meta = {
    description = "Smoothly deprecate and redirect Python functions/classes with smart warnings and auto-routing";
    homepage = "https://github.com/Borda/pyDeprecate";
    changelog = "https://github.com/Borda/pyDeprecate/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mahyarmirrashed ];
  };
})
