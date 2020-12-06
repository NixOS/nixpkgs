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
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ded73e49135c24bd4d3f45bf1eb168f8d290090f5cf4566b8df3698317dc9c08";
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
