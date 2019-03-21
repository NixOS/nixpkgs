{ stdenv, buildPythonPackage, fetchPypi
, enum34, hpack, hyperframe }:

buildPythonPackage rec {
  pname = "h2";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fd07e865a3272ac6ef195d8904de92dc7b38dc28297ec39cfa22716b6d62e6eb";
  };

  propagatedBuildInputs = [ enum34 hpack hyperframe ];

  meta = with stdenv.lib; {
    description = "HTTP/2 State-Machine based protocol implementation";
    homepage = "http://hyper.rtfd.org/";
    license = licenses.mit;
  };
}
