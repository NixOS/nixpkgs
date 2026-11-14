{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,

  # dependencies
  chromadb,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "mempalace";
  version = "3.3.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ttMVcabQIb7kKOQBmO61xXQohfsXLSSDvbtjoaFFhIc=";
  };

  build-system = [ hatchling ];

  dependencies = [
    chromadb
    pyyaml
  ];

  pythonImportsCheck = [ "mempalace" ];

  meta = with lib; {
    description = "Give your AI a memory — mine projects and conversations into a searchable palace";
    homepage = "https://github.com/MemPalace/mempalace";
    license = licenses.mit;
    mainProgram = "mempalace";
  };
}
