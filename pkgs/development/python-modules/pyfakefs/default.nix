{ stdenv, buildPythonPackage, fetchPypi, pytest, unittest2 }:

buildPythonPackage rec {
  version = "3.3";
  pname = "pyfakefs";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19hj5wyi8wy8n8hdj5dwlryl3frrn783y4dsfdxn5mg0lpg9iqg3";
  };

  propagatedBuildInputs = [ pytest unittest2 ];

  meta = with stdenv.lib; {
    description = "Fake file system that mocks the Python file system modules";
    license     = licenses.asl20;
    homepage    = "http://pyfakefs.org/";
    maintainers = with maintainers; [ gebner ];
  };
}
