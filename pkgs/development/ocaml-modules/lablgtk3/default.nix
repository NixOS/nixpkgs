{ lib, fetchurl, pkg-config, buildDunePackage, gtk3, cairo2 }:

buildDunePackage rec {
  version = "3.1.1";
  pname = "lablgtk3";

  minimumOCamlVersion = "4.05";

  src = fetchurl {
    url = "https://github.com/garrigue/lablgtk/releases/download/${version}/lablgtk3-${version}.tbz";
    sha256 = "1ygc1yh99gh44h958yffw1vxdlfpn799d4x1s36c2jfbi8f0dir2";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ gtk3 cairo2 ];

  meta = {
    description = "OCaml interface to GTK 3";
    homepage = "http://lablgtk.forge.ocamlcore.org/";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
