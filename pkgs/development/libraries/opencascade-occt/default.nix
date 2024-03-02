{ lib, stdenv, fetchurl, fetchpatch, cmake, ninja, tcl, tk,
  libGL, libGLU, libXext, libXmu, libXi, darwin }:

stdenv.mkDerivation rec {
  pname = "opencascade-occt";
  version = "7.6.2";
  commit = "V${builtins.replaceStrings ["."] ["_"] version}";

  src = fetchurl {
    name = "occt-${commit}.tar.gz";
    url = "https://git.dev.opencascade.org/gitweb/?p=occt.git;a=snapshot;h=${commit};sf=tgz";
    sha256 = "sha256-n3KFrN/mN1SVXfuhEUAQ1fJzrCvhiclxfEIouyj9Z18=";
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
    maintainers = with maintainers; [ amiloradovsky gebner ];
    platforms = platforms.all;
  };

}
