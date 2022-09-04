{ lib, stdenv, fetchurl, fetchpatch, cmake, ninja, tcl, tk,
  libGL, libGLU, libXext, libXmu, libXi, darwin }:

stdenv.mkDerivation rec {
  pname = "opencascade-occt_7.4";
  version = "7.4.0p1";
  commit = "V${builtins.replaceStrings ["."] ["_"] version}";

  src = fetchurl {
    name = "occt-${commit}.tar.gz";
    url = "https://git.dev.opencascade.org/gitweb/?p=occt.git;a=snapshot;h=${commit};sf=tgz";
    sha256 = "0b9hs3akx1f3hhg4zdip6qdv04ssqqcf9kk12amkidgvsl73z2hs";
  };

  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ tcl tk libGL libGLU libXext libXmu libXi ]
    ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Cocoa;

  meta = with lib; {
    description = "Open CASCADE Technology, libraries for 3D modeling and numerical simulation";
    homepage = "https://www.opencascade.org/";
    license = licenses.lgpl21;  # essentially...
    # The special exception defined in the file OCCT_LGPL_EXCEPTION.txt
    # are basically about making the license a little less share-alike.
    maintainers = with maintainers; [ cafkafk ];
    platforms = platforms.all;
  };

}
