{ lib, stdenv, fetchurl, pkg-config, gtk3 }:

stdenv.mkDerivation rec {
  pname = "gtkdatabox";
  version = "1.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/gtkdatabox/${pname}-${version}.tar.gz";
    sha256 = "1qykm551bx8j8pfgxs60l2vhpi8lv4r8va69zvn2594lchh71vlb";
  };

  nativeBuildInputs = [ pkg-config ];

  propagatedBuildInputs = [ gtk3 ];

  meta = {
    description = "GTK widget for displaying large amounts of numerical data";

    license = lib.licenses.lgpl2;

    platforms = lib.platforms.unix;
  };
}
