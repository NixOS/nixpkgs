{ stdenv
, buildPythonPackage
, fetchPypi
, six
, zope_testing
}:

buildPythonPackage rec {
  pname = "manuel";
  version = "1.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fee65086422cf8ccb31182db6e3bcd59f6bc1c8a6d71e35df1d481238f57bfad";
  };

  propagatedBuildInputs = [ six zope_testing ];

  meta = with stdenv.lib; {
    description = "A documentation builder";
    homepage = https://pypi.python.org/pypi/manuel;
    license = licenses.zpl20;
  };

}
