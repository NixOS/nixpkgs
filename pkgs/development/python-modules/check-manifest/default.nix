{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "check-manifest";
  version = "0.37";

  src = fetchPypi {
    inherit pname version;
    sha256 = "44e3cf4b0833a55460046bf7a3600eaadbcae5e9d13baf0c9d9789dd5c2c6452";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/mgedmin/check-manifest;
    description = "Check MANIFEST.in in a Python source package for completeness";
    license = licenses.mit;
    maintainers = with maintainers; [ lewo ];
  };
}
