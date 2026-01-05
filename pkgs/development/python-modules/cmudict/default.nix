{
  lib,
  buildPythonPackage,
  fetchPypi,
  importlib-metadata,
  importlib-resources,
  poetry-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "cmudict";
  version = "1.1.3";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-9sHLmi/+zvOHvxobk75sYckbxvQXFPGDw+tNWz4f9fY=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    importlib-metadata
    importlib-resources
  ];

  pythonImportsCheck = [ "cmudict" ];

  meta = {
    description = "Python wrapper package for The CMU Pronouncing Dictionary data files";
    homepage = "https://github.com/prosegrinder/python-cmudict";
    changelog = "https://github.com/prosegrinder/python-cmudict/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sandarukasa ];
  };
})
