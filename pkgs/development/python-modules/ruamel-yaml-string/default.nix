{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ruamel-yaml-string";
  version = "0.1.1";

  src = fetchPypi {
    inherit version;
    pname = "ruamel.yaml.string";
    hash = "sha256-enrtzAVdRcAE04t1b1hHTr77EGhR9M5WzlhBVwl4Q1A=";
  };

  nativeBuildInputs = [ setuptools ];

  doCheck = false;

  pythonImportsCheck = [ "ruamel.yaml.string" ];

  meta = with lib; {
    description = "add dump_to_string/dumps method that returns YAML document as string";
    homepage = "";
    license = licenses.mit;
    maintainers = [ ];
  };
}
