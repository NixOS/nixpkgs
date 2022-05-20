{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, six
, zope_testing
}:

buildPythonPackage rec {
  pname = "manuel";
  version = "1.11.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-nJt3WMQ66oa3VlW5InJCzOea96Wf7WwxSbBp9WIfzqc=";
  };

  propagatedBuildInputs = [ six ];
  checkInputs = [ zope_testing ];

  meta = with lib; {
    description = "A documentation builder";
    homepage = "https://pypi.python.org/pypi/manuel";
    license = licenses.zpl20;
  };

}
