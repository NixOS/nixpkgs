{ stdenv, buildPythonPackage, fetchPypi, pytest, unittest2 }:

buildPythonPackage rec {
  version = "3.4.1";
  pname = "pyfakefs";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "96f1d008ae6cc4d9866dd674ee852748a11c67784f1f369221a5fd2750cc0883";
  };

  propagatedBuildInputs = [ pytest unittest2 ];

  meta = with stdenv.lib; {
    description = "Fake file system that mocks the Python file system modules";
    license     = licenses.asl20;
    homepage    = "http://pyfakefs.org/";
    maintainers = with maintainers; [ gebner ];
  };
}
