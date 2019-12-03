{ stdenv, buildPythonPackage, fetchPypi, requests, protobuf, pycryptodome }:

buildPythonPackage rec {
  version = "0.4.4";
  pname = "gpapi";

  src = fetchPypi {
    inherit version pname;
    sha256 = "0ampvsv97r3hy1cakif4kmyk1ynf3scbvh4fbk02x7xrxn4kl38w";
  };

  propagatedBuildInputs = [ requests protobuf pycryptodome ];

  meta = with stdenv.lib; {
    homepage = https://github.com/NoMore201/googleplay-api;
    license = licenses.gpl3;
    description = "Google Play Unofficial Python API";
    maintainers = with maintainers; [ ma27 ];
  };
}
