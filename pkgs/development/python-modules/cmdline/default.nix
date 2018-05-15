{ stdenv, buildPythonPackage, fetchPypi, pyyaml }:

buildPythonPackage rec {
  pname = "cmdline";
  version = "0.1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "324cc8fc6580f221824821c47232c297ed1f7cc737186a57305a8c08fc902dd7";
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
