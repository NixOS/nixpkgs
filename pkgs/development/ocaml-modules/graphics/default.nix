{ lib, fetchurl, buildDunePackage, dune-configurator, libX11 }:

buildDunePackage rec {

  pname = "graphics";
  version = "5.1.1";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/ocaml/graphics/releases/download/${version}/graphics-${version}.tbz";
    sha256 = "sha256-KGyD497ZKHA2xeXHezmh3P1zoSlre1h5N9zjkAFmMo4=";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ libX11 ];

  meta = {
    homepage = "https://github.com/ocaml/graphics";
    description = "A set of portable drawing primitives";
    license = lib.licenses.lgpl2;
  };
}
