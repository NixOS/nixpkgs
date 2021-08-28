{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, six
, zope_testing
}:

buildPythonPackage rec {
  pname = "manuel";
  version = "1.10.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bdzay7j70fly5fy6wbdi8fbrxjrrlxnxnw226rwry1c8a351rpy";
  };

  propagatedBuildInputs = [ six ];
  checkInputs = [ zope_testing ];

  meta = with lib; {
    description = "A documentation builder";
    homepage = "https://pypi.python.org/pypi/manuel";
    license = licenses.zpl20;
  };

}
