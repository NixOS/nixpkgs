{ stdenv
, buildPythonPackage
, fetchPypi
, six
, zope_testing
}:

buildPythonPackage rec {
  pname = "manuel";
  version = "1.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d324983db5d8e3f36ff20732a723cf0af2e2477d569f871fc649f08b782fa8f1";
  };

  propagatedBuildInputs = [ six zope_testing ];

  meta = with stdenv.lib; {
    description = "A documentation builder";
    homepage = https://pypi.python.org/pypi/manuel;
    license = licenses.zpl20;
  };

}
