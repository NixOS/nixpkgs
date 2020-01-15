{ lib, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "cfgv";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0i1iam461bd6bphd402r7payr2m71xivy5zp6k2gjnv67fa8gczd";
  };

  propagatedBuildInputs = [ six ];

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "Validate configuration and produce human readable error messages";
    homepage = https://github.com/asottile/cfgv;
    license = licenses.mit;
  };
}
