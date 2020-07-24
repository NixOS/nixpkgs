{ stdenv, buildPythonPackage, fetchPypi
, enum34, hpack, hyperframe }:

buildPythonPackage rec {
  pname = "h2";
  version = "3.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "051gg30aca26rdxsmr9svwqm06pdz9bv21ch4n0lgi7jsvml2pw7";
  };

  propagatedBuildInputs = [ enum34 hpack hyperframe ];

  meta = with stdenv.lib; {
    description = "HTTP/2 State-Machine based protocol implementation";
    homepage = "http://hyper.rtfd.org/";
    license = licenses.mit;
  };
}
