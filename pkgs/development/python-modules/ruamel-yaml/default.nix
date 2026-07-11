{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  ruamel-base,
  ruamel-yaml-clib,
  isPyPy,
}:

buildPythonPackage rec {
  pname = "ruamel-yaml";
  version = "0.19.1";
  pyproject = true;

  src = fetchPypi {
    pname = "ruamel_yaml";
    inherit version;
    hash = "sha256-U+tmzSeEnv+Wjr+PC/YfRs2sLaHR81dt1MzumyXDGZM=";
  };

  nativeBuildInputs = [ setuptools ];

  # Tests use relative paths
  doCheck = false;

  propagatedBuildInputs = [ ruamel-base ] ++ lib.optional (!isPyPy) ruamel-yaml-clib;

  pythonImportsCheck = [ "ruamel.yaml" ];

  meta = {
    description = "YAML parser/emitter that supports roundtrip preservation of comments, seq/map flow style, and map key order";
    homepage = "https://sourceforge.net/projects/ruamel-yaml/";
    changelog = "https://sourceforge.net/p/ruamel-yaml/code/ci/default/tree/CHANGES";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
