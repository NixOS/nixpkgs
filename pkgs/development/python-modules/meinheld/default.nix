{ stdenv, fetchPypi, buildPythonPackage, greenlet }:

buildPythonPackage rec {
  pname = "meinheld";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "447de7189e4dc9c1f425aa1b9c8210aab492fda4d86f73a24059264e7d8b0134";
  };

  propagatedBuildInputs = [ greenlet ];

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "High performance asynchronous Python WSGI Web Server";
    homepage = http://meinheld.org/;
    license = licenses.bsd3;
  };
}
