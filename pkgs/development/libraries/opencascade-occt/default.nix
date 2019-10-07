{ stdenv, fetchurl, fetchpatch, cmake, ninja, tcl, tk,
  libGL, libGLU, libXext, libXmu, libXi }:

stdenv.mkDerivation rec {
  pname = "opencascade-occt";
  version = "7.4.0";
  commit = "V${builtins.replaceStrings ["."] ["_"] version}";

  src = fetchurl {
    name = "occt-${commit}.tar.gz";
    url = "https://git.dev.opencascade.org/gitweb/?p=occt.git;a=snapshot;h=${commit};sf=tgz";
    sha256 = "0n6p9bjxi7j6aqf2wmhx31lhmmkizgychzri4l5y6lzgbh3w454n";
  };

  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ tcl tk libGL libGLU libXext libXmu libXi ];

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
