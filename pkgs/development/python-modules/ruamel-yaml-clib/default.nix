{
  lib,
  buildPythonPackage,
  fetchhg,
  setuptools,
  cython,
}:

buildPythonPackage rec {
  pname = "ruamel-yaml-clib";
  version = "0.2.12";
  pyproject = true;

  src = fetchhg {
    url = "http://hg.code.sf.net/p/ruamel-yaml-clib/code";
    rev = version;
    hash = "sha256-VKiNt2WJttVjMR0z4bvdSYKOZqycRONCSPQacAy5PYo=";
  };

  build-system = [ setuptools ];

  # no tests
  doCheck = false;

  # circular dependency with ruamel-yaml
  # pythonImportsCheck = [ "_ruamel_yaml" ];
  nativeBuildInputs = [ cython ];

  preBuild = "cython _ruamel_yaml.pyx -3 --module-name _ruamel_yaml -I.";

  meta = with lib; {
    description = "YAML parser/emitter that supports roundtrip preservation of comments, seq/map flow style, and map key order";
    homepage = "https://sourceforge.net/projects/ruamel-yaml-clib/";
    license = licenses.mit;
    maintainers = [ ];
  };
}
