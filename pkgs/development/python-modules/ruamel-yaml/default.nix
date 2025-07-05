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
  version = "0.18.10";
  pyproject = true;

  src = fetchPypi {
    pname = "ruamel.yaml";
    inherit version;
    hash = "sha256-IMhqsprCFT+ApCjhJUqK32htM4PfBEkFFMo7eaNi21g=";
  };

  patches = [
    # TODO: Upstream
    ./automagic-detect.patch
  ];

  build-system = [ setuptools ];
  dependencies = [
    setuptools # pkg_resources
    ruamel-base
  ] ++ lib.optionals (!isPyPy) [ ruamel-yaml-clib ];

  # Tests use relative paths
  doCheck = false;

  pythonImportsCheck = [ "ruamel.yaml" ];

  meta = with lib; {
    description = "YAML parser/emitter that supports roundtrip preservation of comments, seq/map flow style, and map key order";
    homepage = "https://sourceforge.net/projects/ruamel-yaml/";
    changelog = "https://sourceforge.net/p/ruamel-yaml/code/ci/default/tree/CHANGES";
    license = licenses.mit;
    maintainers = [ ];
  };
}
