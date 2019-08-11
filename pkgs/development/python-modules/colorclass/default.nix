{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "colorclass";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b05c2a348dfc1aff2d502527d78a5b7b7e2f85da94a96c5081210d8e9ee8e18b";
  };

  # No tests in archive
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/Robpol86/colorclass;
    license = licenses.mit;
    description = "Automatic support for console colors";
  };
}
