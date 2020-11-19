{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, faker
, python
, ipaddress
}:

buildPythonPackage rec {
  pname = "factory_boy";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2ce2f665045d9f15145a6310565fcb8255d52fc6fd867f3b783b3ac3de6cf10e";
  };

  propagatedBuildInputs = [ faker ] ++ lib.optionals isPy27 [ ipaddress ];

  # tests not included with pypi release
  doCheck = false;

  meta = with lib; {
    description = "A Python package to create factories for complex objects";
    homepage    = "https://github.com/rbarrois/factory_boy";
    license     = licenses.mit;
  };

}
