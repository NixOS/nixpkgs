{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "dj-database-url";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4aeaeb1f573c74835b0686a2b46b85990571159ffc21aa57ecd4d1e1cb334163";
  };

  # Tests access a DB via network
  doCheck = false;

  meta = with lib; {
    description = "Use Database URLs in your Django Application";
    homepage = https://github.com/kennethreitz/dj-database-url;
    license = licenses.bsd2;
  };
}
