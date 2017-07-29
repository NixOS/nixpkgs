{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "astor";
  version = "0.5";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fdafq5hkis1fxqlmhw0sn44zp2ar46nxhbc22cvwg7hsd8z5gsa";
  };

  meta = with stdenv.lib; {
    description = "Library for reading, writing and rewriting python AST";
    homepage = https://github.com/berkerpeksag/astor;
    license = licenses.bsd3;
    maintainers = with maintainers; [ nixy ];
  };
}
