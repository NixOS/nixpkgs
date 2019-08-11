{ stdenv, fetchPypi, buildPythonPackage, greenlet }:

buildPythonPackage rec {
  pname = "meinheld";
  version = "0.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rg5878njn66cc0x2fwrakikz24946r0cxxl6j8vvz5phd4zygi9";
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
