{ lib, fetchurl, pkgconfig, buildDunePackage, gtk3, cairo2 }:

buildDunePackage rec {
  version = "3.1.0";
  pname = "lablgtk3";

  minimumOCamlVersion = "4.05";

  src = fetchurl {
    url = "https://github.com/garrigue/lablgtk/releases/download/${version}/lablgtk3-${version}.tbz";
    sha256 = "1fn04qwgkwc86jndlrnv4vxcmasjsp1mmcgfznahj1ccc7bv47sv";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk3 ];
  propagatedBuildInputs = [ cairo2 ];

  meta = {
    description = "OCaml interface to GTK 3";
    homepage = "http://lablgtk.forge.ocamlcore.org/";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
