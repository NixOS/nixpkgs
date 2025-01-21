{
  lib,
  buildPythonPackage,
  fetchhg,
  cython,
}:

buildPythonPackage rec {
  pname = "ruamel-yaml-clib";
  version = "0.2.7";
  format = "setuptools";

  src = fetchhg {
    url = "http://hg.code.sf.net/p/ruamel-yaml-clib/code";
    rev = version;
    sha256 = "sha256-QNJyJWfCT8zEvrqI65zPlWIMSRZSoDwIAbFU48TfO4U=";
  };

  # no tests
  doCheck = false;

  # circular dependency with ruamel-yaml
  # pythonImportsCheck = [ "_ruamel_yaml" ];
  nativeBuildInputs = [ cython ];

  # Fix incompatible function pointer conversion errors with clang 16.
  patches = [ ./fix-incompatible-function-pointers.patch ];
  preBuild = "cython _ruamel_yaml.pyx -3 --module-name _ruamel_yaml -I.";

  meta = with lib; {
    description = "YAML parser/emitter that supports roundtrip preservation of comments, seq/map flow style, and map key order";
    homepage = "https://sourceforge.net/projects/ruamel-yaml-clib/";
    license = licenses.mit;
    maintainers = [ ];
  };
}
