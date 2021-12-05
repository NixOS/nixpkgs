{ lib, buildPythonPackage, fetchhg }:

buildPythonPackage rec {
  pname = "ruamel-yaml-clib";
  version = "0.2.4";

  src = fetchhg {
    url = "http://hg.code.sf.net/p/ruamel-yaml-clib/code";
    rev = version;
    sha256 = "sha256-HQZY1opUvVQdXUHmsZmcYX2vfgjKsl6xATmVIXjnBlc=";
  };

  # no tests
  doCheck = false;

  # circular depedency with ruamel-yaml
  # pythonImportsCheck = [ "_ruamel_yaml" ];

  meta = with lib; {
    description =
      "YAML parser/emitter that supports roundtrip preservation of comments, seq/map flow style, and map key order";
    homepage = "https://sourceforge.net/projects/ruamel-yaml-clib/";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
