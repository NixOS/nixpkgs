{ stdenv, fetchurl, pkgconfig, check, cppunit, perl, pythonPackages }:

# NOTE: for subunit python library see pkgs/top-level/python-packages.nix

stdenv.mkDerivation rec {
  name = "subunit-${version}";
  version = "1.0.0";

  src = fetchurl {
    url = "https://launchpad.net/subunit/trunk/${version}/+download/${name}.tar.gz";
    sha256 = "1fnhrrwww90746an2nz2kn9qdf9pklmaf5lm22gssl6648f2rp2m";
  };

  buildInputs = [ pkgconfig check cppunit perl pythonPackages.wrapPython ];

  propagatedBuildInputs = with pythonPackages; [ testtools testscenarios ];

  postFixup = "wrapPythonPrograms";

  meta = with stdenv.lib; {
    description = "A streaming protocol for test results";
    homepage = https://launchpad.net/subunit;
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
