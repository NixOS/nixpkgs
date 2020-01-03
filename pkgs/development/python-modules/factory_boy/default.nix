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
  version = "2.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0w53hjgag6ad5i2vmrys8ysk54agsqvgbjy9lg8g0d8pi9h8vx7s";
  };

  propagatedBuildInputs = [ faker ] ++ lib.optionals isPy27 [ ipaddress ];

  # tests not included with pypi release
  doCheck = false;

  meta = with lib; {
    description = "A Python package to create factories for complex objects";
    homepage    = https://github.com/rbarrois/factory_boy;
    license     = licenses.mit;
  };

}
