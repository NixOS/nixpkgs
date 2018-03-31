{ stdenv, buildPythonPackage, fetchPypi, pyyaml }:

buildPythonPackage rec {
  pname = "cmdline";
  version = "0.1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0sjkcfp4w3rxy2lm2n60dbfkc33kdb3f6254hrrvn4ci3rqv8b5y";
  };

  # No tests, https://github.com/rca/cmdline/issues/1
  doCheck = false;
  propagatedBuildInputs = [ pyyaml ];

  meta = with stdenv.lib; {
    description = "Utilities for consistent command line tools";
    homepage = https://github.com/rca/cmdline;
    license = licenses.asl20;
  };
}
