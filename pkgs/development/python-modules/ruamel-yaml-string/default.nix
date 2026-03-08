{
  lib,
  buildPythonPackage,
  pythonAtLeast,
  fetchPypi,
  setuptools,
  ruamel-yaml,
}:

buildPythonPackage (finalAttrs: {
  pname = "ruamel-yaml-string";
  version = "0.1.1";
  pyproject = true;

  # ImportError: cannot import name 'Str' from 'ast'
  disabled = pythonAtLeast "3.14";

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "ruamel.yaml.string";
    hash = "sha256-enrtzAVdRcAE04t1b1hHTr77EGhR9M5WzlhBVwl4Q1A=";
  };

  build-system = [ setuptools ];

  dependencies = [ ruamel-yaml ];

  pythonImportsCheck = [ "ruamel.yaml" ];

  meta = {
    description = "Add dump_to_string/dumps method that returns YAML document as string";
    homepage = "https://sourceforge.net/projects/ruamel-yaml-string/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fbeffa ];
  };
})
