{ stdenv
, buildPythonPackage
, fetchPypi
, faker
, python
}:

buildPythonPackage rec {
  pname = "factory_boy";
  version = "2.11.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6f25cc4761ac109efd503f096e2ad99421b1159f01a29dbb917359dcd68e08ca";
  };

  propagatedBuildInputs = [ faker ];

  # tests not included with pypi release
  doCheck = false;

  checkPhase = ''
    ${python.interpreter} -m unittest
  '';

  meta = with stdenv.lib; {
    description = "A Python package to create factories for complex objects";
    homepage    = https://github.com/rbarrois/factory_boy;
    license     = licenses.mit;
  };

}
