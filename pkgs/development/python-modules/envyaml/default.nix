{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  pyyaml,
}:

buildPythonPackage (finalAttrs: {
  pname = "envyaml";
  version = "1.10.211231";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-iPigdhWePDF9NFCl9AQTK2rJGuzuSTTqcurGX5EfEkQ=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [ pyyaml ];

  pythonImportsCheck = [ "envyaml" ];

  meta = {
    description = "Simple YAML configuration file parser ";
    homepage = "https://github.com/thesimj/${finalAttrs.pname}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lucperkins ];
  };
})
