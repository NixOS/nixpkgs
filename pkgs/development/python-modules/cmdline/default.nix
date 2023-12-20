{ lib, buildPythonPackage, fetchPypi, pyyaml }:

buildPythonPackage rec {
  pname = "cmdline";
  version = "0.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7cf6af53549892b2218c2f56a199dff54a733be5c5515c0fd626812070b0a86a";
  };

  # No tests, https://github.com/rca/cmdline/issues/1
  doCheck = false;
  propagatedBuildInputs = [ pyyaml ];

  meta = with lib; {
    description = "Utilities for consistent command line tools";
    homepage = "https://github.com/rca/cmdline";
    license = licenses.asl20;
  };
}
