{ buildPythonPackage, fetchPypi, lib }:
buildPythonPackage rec {
  pname = "cli-formatter";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Vpi2R0DHL9ouxsEtcyJx+reMjItlvtihfbMxJbECfak=";
  };

  meta = {
    description = "Utility for formatting console output for cli scripts";
    homepage = "https://github.com/wahlflo/cli-formatter";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.symphorien ];
  };
}
