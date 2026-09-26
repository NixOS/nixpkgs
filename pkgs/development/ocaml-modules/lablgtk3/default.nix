{
  lib,
  fetchurl,
  pkg-config,
  buildDunePackage,
  dune-configurator,
  gtk3,
  cairo2,
  camlp-streams,
}:

buildDunePackage (finalAttrs: {
  version = "3.1.5";
  pname = "lablgtk3";

  minimalOCamlVersion = "4.06";

  src = fetchurl {
    url = "https://github.com/garrigue/lablgtk/releases/download/${finalAttrs.version}/lablgtk3-${finalAttrs.version}.tbz";
    hash = "sha256-1IIc2+zzrjdPIDF9Y+Q/5YAww7qWV7UaLoPmUhl+jqw=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    dune-configurator
    camlp-streams
  ];
  propagatedBuildInputs = [
    gtk3
    cairo2
  ];

  meta = {
    description = "OCaml interface to GTK 3";
    homepage = "http://lablgtk.forge.ocamlcore.org/";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.vbgl ];
  };
})
