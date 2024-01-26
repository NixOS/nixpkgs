{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "colorclass";
  version = "2.2.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6d4fe287766166a98ca7bc6f6312daf04a0481b1eda43e7173484051c0ab4366";
  };

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/Robpol86/colorclass";
    license = licenses.mit;
    description = "Automatic support for console colors";
  };
}
