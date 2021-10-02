{ lib, stdenv, fetchurl, pkg-config, check, cppunit, perl, python3Packages }:

# NOTE: for subunit python library see pkgs/top-level/python-packages.nix

stdenv.mkDerivation rec {
  pname = "subunit";
  version = "1.4.0";

  src = fetchurl {
    url = "https://launchpad.net/subunit/trunk/${version}/+download/${pname}-${version}.tar.gz";
    sha256 = "1h7i5ifcx20qkya24j11nbwa829klw7dvnlljdgivgvcx6b20y80";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ check cppunit perl python3Packages.wrapPython ];

  propagatedBuildInputs = with python3Packages; [ testtools testscenarios ];

  postFixup = "wrapPythonPrograms";

  meta = with lib; {
    description = "A streaming protocol for test results";
    homepage = "https://launchpad.net/subunit";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
