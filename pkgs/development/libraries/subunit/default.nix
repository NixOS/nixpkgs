{ lib, stdenv, fetchurl, pkg-config, check, cppunit, perl, python3Packages }:

# NOTE: for subunit python library see pkgs/top-level/python-packages.nix

stdenv.mkDerivation rec {
  pname = "subunit";
  version = "1.4.2";

  src = fetchurl {
    url = "https://launchpad.net/subunit/trunk/${version}/+download/${pname}-${version}.tar.gz";
    hash = "sha256-hlOOv6kIC97w7ICVsuXeWrsUbVu3tCSzEVKUHXYG2dI=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ check cppunit perl python3Packages.wrapPython ];

  propagatedBuildInputs = with python3Packages; [ testtools testscenarios ];

  postFixup = "wrapPythonPrograms";

  meta = with lib; {
    description = "Streaming protocol for test results";
    mainProgram = "subunit-diff";
    homepage = "https://launchpad.net/subunit";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
