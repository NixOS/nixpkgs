{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  ruamel-yaml,
}:

buildPythonPackage rec {
  pname = "ruamel-yaml-string";
  version = "0.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "ruamel.yaml.string";
    hash = "sha256-enrtzAVdRcAE04t1b1hHTr77EGhR9M5WzlhBVwl4Q1A=";
  };

  build-system = [ setuptools ];

  dependencies = [ ruamel-yaml ];

  pythonImportsCheck = [ "ruamel.yaml" ];

  meta = with lib; {
    description = "Add dump_to_string/dumps method that returns YAML document as string";
    homepage = "https://sourceforge.net/projects/ruamel-yaml-string/";
    license = licenses.mit;
    maintainers = with maintainers; [ fbeffa ];
  };
}
