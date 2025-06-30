{
  lib,
  buildPythonPackage,
  fetchhg,
  setuptools,
  ruamel-base,
  ruamel-yaml-clib,
  isPyPy,
}:

buildPythonPackage rec {
  pname = "ruamel-yaml";
  version = "0.18.10";
  pyproject = true;

  src = fetchhg {
    url = "http://hg.code.sf.net/p/ruamel-yaml/code";
    # tag = version;
    rev = version;
    hash = "sha256-bO+UMnIKZHz1+cPrrnhyzowUCLFsWV/OHaGmfipYt7c=";
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

  meta = {
    description = "YAML parser/emitter that supports roundtrip preservation of comments, seq/map flow style, and map key order";
    homepage = "https://sourceforge.net/projects/ruamel-yaml/";
    changelog = "https://sourceforge.net/p/ruamel-yaml/code/ci/default/tree/CHANGES";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
