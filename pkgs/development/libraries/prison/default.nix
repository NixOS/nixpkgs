{ lib, stdenv, fetchurl, cmake, qrencode, qt4, libdmtx }:

stdenv.mkDerivation rec {
  pname = "prison";
  version = "1.0";

  src = fetchurl {
    url = "mirror://kde/stable/prison/${version}/src/prison-${version}.tar.gz";
    sha256 = "08hkzzda36jpdywjqlyzcvli7cx17h4l9yffzsdnhdd788n28krr";
  };

  buildInputs = [ qt4 qrencode libdmtx ];

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Qt4 library for QR-codes";
    license = lib.licenses.mit;
    inherit (qt4.meta) platforms;
  };
}
