{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "dpkt";
  version = "1.9.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rr9ygczhxkfb61778jx0cxs0sq46zwlcj5l3wn6xmd3iy3yx9y6";
  };

  meta = with stdenv.lib; {
    description = "Fast, simple packet creation / parsing, with definitions for the basic TCP/IP protocols";
    homepage = https://code.google.com/p/dpkt/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.all;
  };
}
