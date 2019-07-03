{ lib, fetchurl, pkgconfig, buildDunePackage, gtk3, cairo2 }:

buildDunePackage rec {
  version = "3.0.beta6";
  pname = "lablgtk3";

  minimumOCamlVersion = "4.05";

  src = fetchurl {
    url = "https://github.com/garrigue/lablgtk/releases/download/${version}/lablgtk3-${version}.tbz";
    sha256 = "1jni5cbp54qs7y0dc5zkm28v2brpfwy5miighv7cy0nmmxrsq520";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk3 ];
  propagatedBuildInputs = [ cairo2 ];

  meta = {
    description = "OCaml interface to gtk+-3";
    homepage = "http://lablgtk.forge.ocamlcore.org/";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
