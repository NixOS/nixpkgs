{ stdenv, buildPythonPackage, fetchPypi, requests, protobuf, pycryptodome }:

buildPythonPackage rec {
  version = "0.4.3";
  pname = "gpapi";

  src = fetchPypi {
    inherit version pname;
    sha256 = "9fd1351eb29c4da92d3a0ed2cd4e3c1634ea16afddbca133f6acc54766d61b02";
  };

  propagatedBuildInputs = [ requests protobuf pycryptodome ];

  meta = with stdenv.lib; {
    homepage = https://github.com/NoMore201/googleplay-api;
    license = licenses.gpl3;
    description = "Google Play Unofficial Python API";
    maintainers = with maintainers; [ ma27 ];
  };
}
