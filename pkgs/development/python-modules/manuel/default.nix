{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, six
, zope_testing
}:

buildPythonPackage rec {
  pname = "manuel";
  version = "1.12.4";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-A5Wq32mR+SSseVz61Z2l3AYYcyqMxYrQ9HSWWrco9/Q=";
  };

  propagatedBuildInputs = [ six ];
  checkInputs = [ zope_testing ];

  meta = with lib; {
    description = "A documentation builder";
    homepage = "https://pypi.python.org/pypi/manuel";
    license = licenses.zpl20;
  };

}
