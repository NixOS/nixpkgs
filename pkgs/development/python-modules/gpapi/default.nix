{ stdenv, buildPythonPackage, fetchPypi, requests, protobuf, pycryptodome }:

buildPythonPackage rec {
  version = "0.4.2";
  pname = "gpapi";

  src = fetchPypi {
    inherit version pname;
    sha256 = "1fv2y3xbwn512fjxrdwgq6cz0xjd7mh54nq1f18wyz8w40vcznns";
  };

  propagatedBuildInputs = [ requests protobuf pycryptodome ];

  meta = with stdenv.lib; {
    homepage = https://github.com/NoMore201/googleplay-api;
    license = licenses.gpl3;
    description = "Google Play Unofficial Python API";
    maintainers = with maintainers; [ ma27 ];
  };
}
