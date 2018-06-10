{ stdenv, buildPythonPackage, fetchPypi
, enum34, hpack, hyperframe }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "h2";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0r3f43r0v7sqgdjjg5ngw0dndk2v6cyd0jncpwya54m37y42z5mj";
  };

  propagatedBuildInputs = [ enum34 hpack hyperframe ];

  meta = with stdenv.lib; {
    description = "HTTP/2 State-Machine based protocol implementation";
    homepage = "http://hyper.rtfd.org/";
    license = licenses.mit;
  };
}
