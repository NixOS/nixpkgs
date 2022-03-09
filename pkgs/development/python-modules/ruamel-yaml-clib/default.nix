{ lib
, buildPythonPackage
, fetchhg
}:

buildPythonPackage rec {
  pname = "ruamel-yaml-clib";
  version = "0.2.6";
  format = "setuptools";

  src = fetchhg {
    url = "http://hg.code.sf.net/p/ruamel-yaml-clib/code";
    rev = version;
    sha256 = "sha256-mpkh9JhYKRX47jfKprjt1Vpm9DMz8LcWzkotJ+/xoxY=";
  };

  # no tests
  doCheck = false;

  # circular depedency with ruamel-yaml
  # pythonImportsCheck = [ "_ruamel_yaml" ];

  meta = with lib; {
    description = "YAML parser/emitter that supports roundtrip preservation of comments, seq/map flow style, and map key order";
    homepage = "https://sourceforge.net/projects/ruamel-yaml-clib/";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
