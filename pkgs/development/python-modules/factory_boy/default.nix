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
  version = "3.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nsw2mdjk8sqds3qsix4cf19ws6i0fak79349pw2581ryc7w0720";
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
