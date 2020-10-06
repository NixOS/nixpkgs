{ stdenv, fetchurl, fetchpatch, cmake, ninja, tcl, tk,
  libGL, libGLU, libXext, libXmu, libXi, darwin }:

stdenv.mkDerivation rec {
  pname = "opencascade-occt";
  version = "7.3.0p3";
  commit = "V${builtins.replaceStrings ["."] ["_"] version}";

  src = fetchurl {
    name = "occt-${commit}.tar.gz";
    url = "https://git.dev.opencascade.org/gitweb/?p=occt.git;a=snapshot;h=${commit};sf=tgz";
    sha256 = "0k9c3ypcnjcilq1dhsf6xxbd52gyq4h5rchvp30k3c8ph4ris5pz";
  };

  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ tcl tk libGL libGLU libXext libXmu libXi ]
    ++ stdenv.lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Cocoa;

  meta = with stdenv.lib; {
    description = "Open CASCADE Technology, libraries for 3D modeling and numerical simulation";
    homepage = "https://www.opencascade.org/";
    license = licenses.lgpl21;  # essentially...
    # The special exception defined in the file OCCT_LGPL_EXCEPTION.txt
    # are basically about making the license a little less share-alike.
    maintainers = with maintainers; [ amiloradovsky ];
    platforms = platforms.all;
  };

}
