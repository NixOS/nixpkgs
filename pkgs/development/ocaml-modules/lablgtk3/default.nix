{ lib, fetchurl, pkg-config, buildDunePackage, dune-configurator
, gtk3, cairo2
, camlp-streams
}:

buildDunePackage rec {
  version = "3.1.4";
  pname = "lablgtk3";

  minimalOCamlVersion = "4.05";

  src = fetchurl {
    url = "https://github.com/garrigue/lablgtk/releases/download/${version}/lablgtk3-${version}.tbz";
    hash = "sha256-bxEVMzfnaH5yHVxAmifNYOy8GnSivLLgSE/9+1yxBI4=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator camlp-streams ];
  propagatedBuildInputs = [ gtk3 cairo2 ];

  meta = {
    description = "OCaml interface to GTK 3";
    homepage = "http://lablgtk.forge.ocamlcore.org/";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
