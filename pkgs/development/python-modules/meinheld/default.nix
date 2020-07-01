{ stdenv, fetchPypi, buildPythonPackage, greenlet }:

buildPythonPackage rec {
  pname = "meinheld";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "008c76937ac2117cc69e032dc69cea9f85fc605de9bac1417f447c41c16a56d6";
  };

  propagatedBuildInputs = [ greenlet ];

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "High performance asynchronous Python WSGI Web Server";
    homepage = "https://meinheld.org/";
    license = licenses.bsd3;
  };
}
