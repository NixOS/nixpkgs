{ stdenv, buildPythonPackage, fetchPypi
, enum34, hpack, hyperframe }:

buildPythonPackage rec {
  pname = "h2";
  version = "3.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d1svhixk3hr78ph3nx8wi7sagx1xrvm712mmk028i2rhb92p8xq";
  };

  propagatedBuildInputs = [ enum34 hpack hyperframe ];

  meta = with stdenv.lib; {
    description = "HTTP/2 State-Machine based protocol implementation";
    homepage = "http://hyper.rtfd.org/";
    license = licenses.mit;
  };
}
