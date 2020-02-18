{ stdenv
, buildPythonPackage
, fetchhg
, ruamel_base
, ruamel_ordereddict
, isPy3k
}:

buildPythonPackage rec {
  pname = "ruamel.yaml.clib";
  version = "0.2.0";

  src = fetchhg {
    url = "http://hg.code.sf.net/p/ruamel-yaml-clib/code";
    rev = version;
    sha256 = "0kq6zi96qlm72lzj90fc2rfk6nm5kqhk6qxdl8wl9s3a42b0v6wl";
  };

  # outputs match wheel
  doCheck = false;

  meta = with stdenv.lib; {
    description = "YAML parser/emitter that supports roundtrip preservation of comments, seq/map flow style, and map key order";
    homepage = "https://sourceforge.net/projects/ruamel-yaml-clib/";
    license = licenses.mit;
  };

}
