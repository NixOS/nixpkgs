{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "imagesize";
  version = "2.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-srpqTepIen681TJI00dqykSdMNsSot3l4MXKliT9d+U=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "imagesize" ];

  meta = {
    description = "Getting image size from png/jpeg/jpeg2000/gif file";
    homepage = "https://github.com/shibukawa/imagesize_py";
    changelog = "https://github.com/shibukawa/imagesize_py/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
