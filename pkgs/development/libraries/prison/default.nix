{ stdenv, fetchurl, cmake, qrencode, qt4, libdmtx }:

let v = "1.0"; in

stdenv.mkDerivation rec {
  name = "prison-${v}";

  src = fetchurl {
    url = "mirror://kde/stable/prison/${v}/src/${name}.tar.gz";
    sha256 = "08hkzzda36jpdywjqlyzcvli7cx17h4l9yffzsdnhdd788n28krr";
  };

  buildInputs = [ qt4 qrencode libdmtx ];

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Qt4 library for QR-codes";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    inherit (qt4.meta) platforms;
  };
}
